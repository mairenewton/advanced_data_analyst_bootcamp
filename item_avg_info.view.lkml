view: item_avg_info {
  derived_table: {
    explore_source: order_items {
      column: order_item_count {}
      column: total_revenue {}
      column: order_id {}
    }
  }
  dimension: order_item_count {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_id {
    primary_key:  yes
    type: number
  }
  measure: avg_order_item_count {
    type: average
    sql:  ${order_item_count} ;;
  }
  measure: avg_order_price{
    type: average
    sql:  ${total_revenue} ;;
  }

}
