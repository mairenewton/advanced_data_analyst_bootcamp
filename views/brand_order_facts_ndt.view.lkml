view: brand_order_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_revenue {}
      derived_column: brand_rank {
        sql: row_number() over (order by total_revenue desc) ;;
      }
    }
  }
  dimension: brand {primary_key: yes}

  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  measure: sum_total_revenue {
    type: sum
    sql: ${total_revenue} ;;
    value_format: "$#,##0.00"
  }

  dimension: brand_rank {}

  dimension: is_brand_rank_top_5 {
    type: yesno
    sql: ${brand_rank} <= 5 ;;
  }

  dimension: ranked_brand {
    type: string
    sql:
      CASE
        WHEN ${is_brand_rank_top_5} THEN ${brand_rank} || '. ' || ${brand}
        ELSE 'Other'
      END;;
  }

}
