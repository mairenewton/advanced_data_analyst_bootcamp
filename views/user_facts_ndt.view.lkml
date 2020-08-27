# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: users.id }
      column: total_revenue {field: order_items.total_revenue}
      column: order_count {field: order_items.order_count}
      bind_filters: {
        from_field: products.category
        to_field: products.category
      }
    }
  }
  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
    sql: ${TABLE}.total_revenue ;;
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
    sql: ${TABLE}.order_count ;;
  }
}
