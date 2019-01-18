#explore: product_summary {}
view: product_summary {
  derived_table: {
    sql: SELECT DISTINCT category, count(distinct brand) as count_of_brands, count (sku) as count_of_products, avg(cost)
      from public.products
      GROUP BY category
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_count_of_brands {
    type:  sum
    sql: ${count_of_brands} ;;
  }

  measure: total_count_of_products {
    type:  sum
    sql: ${count_of_products} ;;
  }

  dimension: category {
    primary_key: yes
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: count_of_brands {
    type: number
    sql: ${TABLE}.count_of_brands ;;
  }

  dimension: count_of_products {
    type: number
    sql: ${TABLE}.count_of_products ;;
  }

  dimension: avg {
    type: number
    sql: ${TABLE}.avg ;;
  }

  set: detail {
    fields: [category, count_of_brands, count_of_products, avg]
  }
}
