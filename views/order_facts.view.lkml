view: order_facts {
  derived_table: {
    sql: select
      product_sku as product_sku,
      sum(cost) as total_cost,
      sum(case when sold_at is not null then cost else null end ) cost_of_goods_sold
      from public.inventory_items
      group by 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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

  dimension: percentage_inventory_sold {
    type: number
    sql: 1.0*${cost_of_goods_sold}/${total_cost} ;;
    value_format_name: percent_2
  }

  set: detail {
    fields: [product_sku, total_cost, cost_of_goods_sold]
  }
}
