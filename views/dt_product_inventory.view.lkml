view: dt_product_inventory {
  derived_table: {
    sql: SELECT
       product_sku AS product_sku
        ,SUM(cost) AS total_cost
      ,SUM(CASE WHEN sold_at is not null THEN cost ELSE NULL END) AS cost_of_goods_sold
      FROM public.inventory_items
      GROUP BY 1
       ;;
  }

  dimension: product_sku {
    primary_key: yes
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension: total_cost {
    type: number
    sql: ${TABLE}.total_cost ;;
  }

  dimension: cost_of_goods_sold {
    type: number
    sql: ${TABLE}.cost_of_goods_sold ;;
  }

  dimension: percent_of_total_sold {
    type: number
    sql:  ${TABLE}.cost_of_goods_sold/${total_cost} ;;
    value_format_name: percent_2
  }

  measure: average_percent_sold{
    type:  average
    sql: ${percent_of_total_sold} ;;
    value_format_name: percent_1
  }
  set: detail {
    fields: [product_sku, total_cost, cost_of_goods_sold]
  }
}
