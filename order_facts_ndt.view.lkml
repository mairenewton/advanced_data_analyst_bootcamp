view: order_facts_ndt {

    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {}
        column: total_revenue {}
      }
    }
    dimension: order_id {
      primary_key: yes
      type: number
    }
    dimension: order_item_count {
      type: number
    }
    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }


  measure: avg_number_of_items_purch {
    type: average
    sql: ${order_item_count} ;;
  }

  measure: avg_revenue_of_items_purch {
    type: average
    sql: ${total_revenue} ;;
  }

}
