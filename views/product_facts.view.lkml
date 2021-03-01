view: product_facts {
  derived_table: {
    sql: SELECT product_sku AS product_sku ,SUM(cost) AS total_cost ,SUM(CASE WHEN sold_at is not null THEN cost ELSE NULL END) AS cost_of_goods_sold FROM public.inventory_items GROUP BY 1
      ;;
  }

  measure: count {
    hidden:  yes
    type: count
    drill_fields: [detail*]
  }

  dimension: product_sku {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.product_sku ;;
  }


  dimension: total_cost {
    type: number
    hidden: yes
    sql: ${TABLE}.total_cost ;;
  }

  dimension: cost_of_goods_sold {
    hidden: yes
    type: number
    sql: ${TABLE}.cost_of_goods_sold ;;
  }

  measure: total_cost_of_goods_sold {
    type:  sum
    sql:  ${cost_of_goods_sold};;
    value_format_name: usd
  }

  measure: total_cost_of_goods {
    type: sum
    sql:  ${total_cost} ;;
    value_format_name: usd
  }

  measure: percentage_of_inventory_sold {
    label: "Percentage of inventory sold"
    type: number
    sql:  ${total_cost_of_goods_sold}/${total_cost_of_goods} ;;
    value_format_name: percent_2
  }

  set: detail {
    fields: [product_sku, total_cost, cost_of_goods_sold]
  }
}
