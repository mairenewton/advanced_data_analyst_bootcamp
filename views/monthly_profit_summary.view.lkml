
view: monthly_profit_summary {
  derived_table: {
    explore_source: order_items {
      column: total_profit {}
      column: created_month {}
      column: order_item_count {}
      derived_column: total_per_item_profit {
        sql: total_profit/order_item_count ;;
        }
      derived_column: total_profit_per_lag {
        sql:  lag( total_profit/order_item_count, 12 ) over(order by created_month asc) ;;
      }
    }
  }

  dimension: total_profit {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: created_month {
    description: "When the order was created"
    type: date_month
  }

  dimension: order_item_count {
    type: number
  }

  dimension: total_per_item_profit {
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_total_profit {
    value_format: "$#,##0.00"
    type: average
    sql: ${total_per_item_profit} ;;
  }

  measure: average_total_profit_per_item_yearoveryear {
    value_format: "$#,##0.00"
    type: average
    sql: ${total_per_item_profit}/total_profit_per_lag ;;
  }

}
