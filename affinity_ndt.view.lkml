# AFFINITY ANALYSIS BLOCK
############################################################
## DEVELOPER WILL READ AND MAKE UPDATES IN THIS SECTION
# Paste this code in your model file.
# Follow steps to add extenal dependency #*link or steps#
# REQUIRED UPDATES:
# 1) explore_soure: MY_EXPLORE_NAME
# 2) field: MY_VIEW_NAME.MY_FIELD_NAME - for both parent and child fields (Note: must be valid for the explore_source)
view: affinity_analysis_input {
  extends: [affinity_analysis_base]
  derived_table: {
    explore_source: order_items {
      column: order_id {field: order_items.order_id}
      column: product_name {field: products.name}
    }
  }
}
explore: affinity_analysis {from:affinity_analysis_input extends:[affinity_analysis_base_explore]}
## END OF CODE DEVELOPER NEEDS TO SEE
############################################################



#####################################
#######################
# Helper view to be extended
##### 1) 'PARENT CHILD COMBOS': Get unique child_values on each parent, and create an explore for use in subseqent pdts
# Note: End developer's implementation will override the derived table field references
# High Level Business Concept: Frequency of specific combinations of two 'child_values' (e.g. order_items.brand Levi's and item brand Calvin Klein), (on 'parent_values', like an order)
view: affinity_analysis_base {
  dimension: order_id {description:"Not used in Affinity Analysis Output.  For Reference & Testing"}
  dimension: product_name {label:"Product Name ({% if _view._name == 'self_join' %}B{% else %}A{% endif %})"}
  measure: unique_parent_and_child_combinations {type: count} #NOTE: two of the same item not counted twice
}


explore: affinity_analysis_base_explore {
#   extension: required
  hidden: yes
  from: affinity_analysis_input
  view_name: affinity_analysis
#   from: unique_product_names_per_order
#   view_name:unique_product_names_per_order #explicit because we plan to extend(?)
  persist_for:"99 hours"
  join: self_join {
    view_label: "Affinity Analysis"
    fields: [self_join.product_name] #only need to see the name
    from: affinity_analysis_input
    relationship: one_to_one #don't care/want fanout
    sql_on: ${self_join.order_id} = ${affinity_analysis.order_id} and ${self_join.product_name}<>${affinity_analysis.product_name};;#?use greater than so we don't get repeats of the same combintion in reverse order? #discourse just shows <>
  }
  join: total_order_product_ndt {#subtotal of distinct Parent Event/Values having Child Value A
    fields: []
    relationship: one_to_one #has no measures
    sql_on: ${affinity_analysis.product_name}=${total_order_product_ndt.product_name} ;;
  }
  join: total_order_product_product_b {#subtotal of distinct Parent Event/Values having Child Value B
    fields: []
    from: total_order_product_ndt
    relationship: one_to_one #has no measures
    sql_on: ${self_join.product_name}=${total_order_product_product_b.product_name} ;;
  }
  join: total_orders_ndt {
    fields: []
    type: cross
    relationship: one_to_one
  }
  join: final_calculations {view_label: "Affinity Analysis" sql:;; relationship:one_to_one}#calculations that cross multiple views
}

#######################
###### 2) 'CREATE SUBTOTAL LOOKUP VIEWS': Use unique combinations table/explore from previous steps to get and store count of distinct Parents having each Child_Value, and also grand total of Parent_and_Child combinations, for use in final frequency calculations
view: total_order_product_ndt {
  derived_table: {
    explore_source: affinity_analysis_base_explore {
      column: product_name {field:affinity_analysis.product_name}
      column: total_combinations_for_product {field:affinity_analysis.unique_parent_and_child_combinations}
    }
  }
  dimension: product_name {}
  measure: total_combinations_for_product {type:max}
}
view: total_orders_ndt {
  derived_table: {explore_source: affinity_analysis_base_explore {column: grand_total {field:affinity_analysis.unique_parent_and_child_combinations}}}
  measure: grand_total {type: max}
}

########################
#calculations that cross views defined here
view: final_calculations {
  measure: product_a_order_frequency {
    description: "How frequently orders include product A as a percent of total orders"
    type: number
    sql: 1.0*${total_order_product_ndt.total_combinations_for_product}/${total_orders_ndt.grand_total} ;;
    value_format: "#.00%"
  }
  measure: product_b_order_frequency {
    description: "How frequently orders include product B as a percent of total orders"
    type: number
    sql: 1.0*${total_order_product_product_b.total_combinations_for_product}/${total_orders_ndt.grand_total} ;;
    value_format: "#.00%"
  }
  measure: joint_order_frequency {
    description: "How frequently orders include both product A and B as a percent of total orders"
    type: number
    sql: 1.0*${affinity_analysis.unique_parent_and_child_combinations}/${total_orders_ndt.grand_total} ;;
    value_format: "#.00%"
  }
  # Affinity Metrics
  measure: add_on_frequency {
    description: "How many times both Products are purchased when Product A is purchased"
    type: number
    sql: 1.0*${affinity_analysis.unique_parent_and_child_combinations}/${total_order_product_ndt.total_combinations_for_product} ;;
    value_format: "#.00%"
  }
  measure: lift {
    description: "The likelihood that buying product A drove the purchase of product B"
    type: number
    sql: ${joint_order_frequency}/(${product_a_order_frequency} * ${product_b_order_frequency}) ;;
    value_format: "#,##0.#0"
  }
  ## Do not display unless users have a solid understanding of  statistics and probability models
  measure: jaccard_similarity {
    description: "The probability both items would be purchased together, should be considered in relation to total order count, the highest score being 1"
    type: number
    sql: 1.0*${affinity_analysis.unique_parent_and_child_combinations}/(${total_order_product_ndt.total_combinations_for_product} + ${total_order_product_product_b.total_combinations_for_product} - ${affinity_analysis.unique_parent_and_child_combinations}) ;;
    value_format: "0.00"
  }
}

###########################
####### 3) Apply Self Join on unique combinations table/explore, then join in SUBTOTAL views. To create a source explore/table for Final NDT
# Self join gives us one row for EVERY COMBINATION(i.e. intentional fanout) of Child Values present on a distinct Parent event/Value
# explore: self_join_explore {
#   persist_for:"99 hours"
#   from: unique_product_names_per_order
#   view_name:unique_product_names_per_order #explicit because we plan to extend(?)
#   join: self {
#     fields: [self.product_name] #only need to see the name
#     from: unique_product_names_per_order
#     relationship: one_to_one #don't care/want fanout
# #? don't think we need, and default of left is fine#   type: inner
#     sql_on: ${self.order_id} = ${unique_product_names_per_order.order_id} and ${self.product_name}<>${unique_product_names_per_order.product_name};;#?use greater than so we don't get repeats of the same combintion in reverse order? #discourse just shows <>
#   }
#   join: total_order_product_ndt {#subtotal of distinct Parent Event/Values having Child Value A
#     fields: []
#     relationship: one_to_one #has no measures
#     sql_on: ${unique_product_names_per_order.product_name}=${total_order_product_ndt.product_name} ;;
#   }
#   join: total_order_product_product_b {#subtotal of distinct Parent Event/Values having Child Value B
#     fields: []
#     from: total_order_product_ndt
#     relationship: one_to_one #has no measures
#     sql_on: ${self.product_name}=${total_order_product_product_b.product_name} ;;
#   }
#   join: total_orders_ndt {
#     fields: []
#     type: cross
#     relationship: one_to_one
#   }
#   join: final_calculations {sql:;; relationship:one_to_one}
# }


# ##########################
# ####5) Final NDT
# # Uses the prepared explore, and
# view: summary_of_combinations_ndt {
#   derived_table: {
#     explore_source: self_join_explore {
#       column: product_a {field:unique_product_names_per_order.product_name}
#       column: product_b {field:self.product_name}
#       column: total_combinations_summary {field:unique_product_names_per_order.unique_parent_and_child_combinations}
#       column: total_combinations_for_product {field:total_order_product_ndt.total_combinations_for_product}
#       column: total_combinations_for_product_b {field:total_order_product_product_b.total_combinations_for_product}
#       column: grand_total {field:total_orders_ndt.grand_total}
#     }
#   }
#   dimension: product_a {}
#   dimension: product_b {}
#
#   dimension: total_combinations_summary {type:number}
#   measure: total_combinations_summary_total {
#     type:sum
#     sql: ${total_combinations_summary} ;;
#   }
#
# #####
#   dimension: total_combinations_for_product {type:number}
#   dimension: total_combinations_for_product_b {type:number}
#   dimension: grand_total {type:number}
# #####
#
#   dimension: product_a_order_frequency {
#     description: "How frequently orders include product A as a percent of total orders"
#     type: number
# #     sql: 1.0*${product_a_order_count}/${total_orders.count} ;;
#     sql: 1.0*${total_combinations_for_product}/${grand_total} ;;
#     value_format: "#.00%"
#   }
#
#   dimension: product_b_order_frequency {
#     description: "How frequently orders include product B as a percent of total orders"
#     type: number
# #     sql: 1.0*${product_b_order_count}/${total_orders.count} ;;
#     sql: 1.0*${total_combinations_for_product_b}/${grand_total} ;;
#     value_format: "#.00%"
#   }
#
#   dimension: joint_order_frequency {
#     description: "How frequently orders include both product A and B as a percent of total orders"
#     type: number
#     sql: 1.0*${total_combinations_summary}/${grand_total} ;;
#     value_format: "#.00%"
#   }
#
#   # Affinity Metrics
#
#   dimension: add_on_frequency {
#     description: "How many times both Products are purchased when Product A is purchased"
#     type: number
# #     sql: 1.0*${joint_order_count}/${product_a_order_count} ;;
#     sql: 1.0*${total_combinations_summary}/${total_combinations_for_product} ;;
#     value_format: "#.00%"
#   }
#
#   dimension: lift {
#     description: "The likelihood that buying product A drove the purchase of product B"
#     type: number
# #     sql: ${joint_order_frequency}/(${product_a_order_frequency} * ${product_b_order_frequency}) ;;
#     sql: ${joint_order_frequency}/(${product_a_order_frequency} * ${product_b_order_frequency}) ;;
#     value_format: "#,##0.#0"
#   }
#
#   ## Do not display unless users have a solid understanding of  statistics and probability models
#   dimension: jaccard_similarity {
#     description: "The probability both items would be purchased together, should be considered in relation to total order count, the highest score being 1"
#     type: number
# #     sql: 1.0*${joint_order_count}/(${product_a_order_count} + ${product_b_order_count} - ${joint_order_count}) ;;
#     sql: 1.0*${total_combinations_summary}/(${total_combinations_for_product} + ${total_combinations_for_product_b} - ${total_combinations_summary}) ;;
#     value_format: "0.00"
#   }
#
# }
#


#   measure: total_combinations_summary {type:number sql:${unique_product_names_per_order.unique_parent_and_child_combinations};;}
#   measure: total_combinations_for_product {type:max sql:${total_order_product_ndt.total_combinations_for_product};;}
#   measure: total_combinations_for_product_b {type:max sql:${total_order_product_product_b.total_combinations_for_product};;}
#   measure: grand_total {type:max sql:${total_orders_ndt.grand_total};;}


#view: affinity_analysis2 {}##tried this with extensions, but the subtotals cause a problem cause they point to the original
#explore: affinity_analysis2 {from: affinity_analysis2 extends:[affinity_analysis_base_explore]}
