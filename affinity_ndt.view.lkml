explore: unique_product_names_per_order_base {} #for testing
explore: total_order_product_ndt {} #for testing
#########

# Developer just has to update the following, to specify the source fields to be used in the affinity analysis
view: unique_product_names_per_order {
  extends: [unique_product_names_per_order_base]
  derived_table: {
    explore_source: events { #YOUR EXPLORE GOES HERE
      column: order_id      {field: events.session_id} #YOUR PARENT_VALUE FIELD GOES HERE
      column: product_name  {field: events.event_type} #YOUR CHILD_VALUE FIELD GOES HERE
#       column: count_orders  {field: events.count}
    }
  }
}

####
# 1) Get Unique Members on each transaction {
# Developer's implementation will override the derived table field references
# Discourse: https://discourse.looker.com/t/analytic-block-affinity-analysis/1476
# High Level Business Concept:
# Frequency of specific combinations of two 'child_values' (e.g. order_items.brand Levi's and item brand Calvin Klein), (on 'parent_values', like an order)
view: unique_product_names_per_order_base {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: product_name {field: products.name} #demo swapping in a different field-># column: product_name { field: products.category }
#       column: count_orders {field: order_items.order_item_count}
    }
  }
  dimension: order_id {primary_key: yes type: number}
  dimension: product_name {}
#   measure: total_count_orders {type: sum sql: ${TABLE}.count_orders ;;}
  measure: unique_parent_and_child_combinations {type: count} #two of the same item not counted twice
}
#end fold}

### 1b) Explore for ndts in the subsequent steps
explore: unique_product_names_per_order {}

#### 2) Get total orders having a given product name {
view: total_order_product_ndt {
  derived_table: {
    explore_source: unique_product_names_per_order {
      column: product_name {}
      column: total_combinations_for_product {field:unique_product_names_per_order.unique_parent_and_child_combinations}
    }
  }
  dimension: product_name {}
  dimension: total_combinations_for_product {}
}


#### 3) get grand total
view: total_orders_ndt {
  derived_table: {
    explore_source: unique_product_names_per_order {
      column: grand_total {field:unique_product_names_per_order.unique_parent_and_child_combinations}
    }
  }
  dimension: grand_total {type:number}
}


### 4) Join the subqueries together
# Self join gives us one row for EVERY COMBINATION(i.e. intentional fanout) of Child Values present on a distinct Parent event/Value
explore: self_join_explore {
  from: unique_product_names_per_order
  view_name:unique_product_names_per_order #explicit because we plan to extend(?)
  join: self {
    from: unique_product_names_per_order
    relationship: one_to_one #don't care about fanout
#? don't think we need, and default of left is fine#   type: inner
    sql_on: ${self.order_id} = ${unique_product_names_per_order.order_id} and ${self.product_name}<>${unique_product_names_per_order.product_name};;#?use greater than so we don't get repeats of the same combintion in reverse order? #discourse just shows <>
  }

  join: total_order_product_ndt {#subtotal of distinct Parent Event/Values having Child Value A
    relationship: many_to_one
    sql_on: ${unique_product_names_per_order.product_name}=${total_order_product_ndt.product_name} ;;
  }
  join: total_order_product_product_b {#subtotal of distinct Parent Event/Values having Child Value B
    from: total_order_product_ndt
    relationship: many_to_one
    sql_on: ${self.product_name}=${total_order_product_product_b.product_name} ;;
  }

  join: total_orders_ndt {
    type: cross
    relationship: one_to_one
  }
}


####5) Final NDT
view: summary_of_combinations_ndt {
  derived_table: {
    explore_source: self_join_explore {
      column: product_a {field:unique_product_names_per_order.product_name}
      column: product_b {field:self.product_name}
      column: total_combinations_summary {field:unique_product_names_per_order.unique_parent_and_child_combinations}
      column: total_combinations_for_product {field:total_order_product_ndt.total_combinations_for_product}
      column: total_combinations_for_product_b {field:total_order_product_product_b.total_combinations_for_product}
      column: grand_total {field:total_orders_ndt.grand_total}
    }
  }
  dimension: product_a {}
  dimension: product_b {}

  dimension: total_combinations_summary {type:number}
  measure: total_combinations_summary_total {
    type:sum
    sql: ${total_combinations_summary} ;;
  }

#####
  dimension: total_combinations_for_product {type:number}
  dimension: total_combinations_for_product_b {type:number}
  dimension: grand_total {type:number}
#####

  dimension: product_a_order_frequency {
    description: "How frequently orders include product A as a percent of total orders"
    type: number
#     sql: 1.0*${product_a_order_count}/${total_orders.count} ;;
    sql: 1.0*${total_combinations_for_product}/${grand_total} ;;
    value_format: "#.00%"
  }

  dimension: product_b_order_frequency {
    description: "How frequently orders include product B as a percent of total orders"
    type: number
#     sql: 1.0*${product_b_order_count}/${total_orders.count} ;;
    sql: 1.0*${total_combinations_for_product_b}/${grand_total} ;;
    value_format: "#.00%"
  }

  dimension: joint_order_frequency {
    description: "How frequently orders include both product A and B as a percent of total orders"
    type: number
    sql: 1.0*${total_combinations_summary}/${grand_total} ;;
    value_format: "#.00%"
  }

  # Affinity Metrics

  dimension: add_on_frequency {
    description: "How many times both Products are purchased when Product A is purchased"
    type: number
#     sql: 1.0*${joint_order_count}/${product_a_order_count} ;;
    sql: 1.0*${total_combinations_summary}/${total_combinations_for_product} ;;
    value_format: "#.00%"
  }

  dimension: lift {
    description: "The likelihood that buying product A drove the purchase of product B"
    type: number
#     sql: ${joint_order_frequency}/(${product_a_order_frequency} * ${product_b_order_frequency}) ;;
    sql: ${joint_order_frequency}/(${product_a_order_frequency} * ${product_b_order_frequency}) ;;
    value_format: "#,##0.#0"
  }

  ## Do not display unless users have a solid understanding of  statistics and probability models
  dimension: jaccard_similarity {
    description: "The probability both items would be purchased together, should be considered in relation to total order count, the highest score being 1"
    type: number
#     sql: 1.0*${joint_order_count}/(${product_a_order_count} + ${product_b_order_count} - ${joint_order_count}) ;;
    sql: 1.0*${total_combinations_summary}/(${total_combinations_for_product} + ${total_combinations_for_product_b} - ${total_combinations_summary}) ;;
    value_format: "0.00"
  }

}
#explore for final afffinity analysis
explore: summary_of_combinations_ndt {persist_for:"99 hours"}
