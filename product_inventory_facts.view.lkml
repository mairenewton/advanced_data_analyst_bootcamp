view: product_inventory_facts {
  derived_table: {
    sql: SELECT
        product_id,
        SUM(CASE WHEN sold_at IS NOT NULL THEN cost ELSE NULL END) as cost_of_goods_sold,
        SUM(cost) as total_cost
      FROM public.inventory_items
      GROUP BY 1
       ;;
  }

#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

  dimension: product_id {
    type: number
    sql: ${TABLE}.product_id ;;
    primary_key: yes
  }

  dimension: cost_of_goods_sold {
    type: number
    sql: ${TABLE}.cost_of_goods_sold ;;
  }

  dimension: total_cost {
    type: number
    sql: ${TABLE}.total_cost ;;
  }

  dimension: percentage_inv_sold {
    type: number
    sql: 1.0*${cost_of_goods_sold}/NULLIF(${total_cost},0) ;;
    value_format_name: percent_1
  }

  measure: avg_percentage_inv_sold {
    type: average
    sql: ${percentage_inv_sold} ;;
    value_format_name: percent_1
  }

  set: detail {
    fields: [product_id, cost_of_goods_sold, total_cost]
  }
}
