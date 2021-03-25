view: inventory_facts {
  derived_table: {
    sql: SELECT
      product_sku,
      sum(cost) as total_cost,
      sum(CASE WHEN SOLD_AT is not null then cost ELSE NULL END) AS cost_of_sold_goods


      FROM public.inventory_items
      GROUP BY 1
       ;;
  }


  dimension: product_sku {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.product_sku ;;
  }

  dimension: total_cost {
    type: number
    hidden: yes
    sql: ${TABLE}.total_cost ;;
  }

  dimension: cost_of_sold_goods {
    type: number
    hidden: yes
    sql: ${TABLE}.cost_of_sold_goods ;;
  }

measure: total_cost_1 {
  type: sum
  value_format_name: usd
  sql: ${total_cost} ;;
}

measure: total_cogs {
  type: sum
  sql: ${cost_of_sold_goods} ;;
}

measure: percent_of_invetory_sold {
  type: number
  value_format_name: percent_2
  sql: ${total_cogs}/${total_cost_1} ;;
}

}
