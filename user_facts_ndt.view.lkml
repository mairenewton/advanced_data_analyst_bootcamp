# include: "advanced_data_analyst_bootcamp.model.lkml"

view: user_facts_2 {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: users.id }
      column: order_count { field: order_items.order_count }
      column: total_revenue {}
      derived_column: row_number {
        sql: row_number() over () ;;
      }
    }
  }
  dimension: user_id {
    primary_key: yes
    type: number
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_order_count {
    type: average
    sql: ${order_count} ;;
  }
}
