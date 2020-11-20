view: brand_top {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_revenue {}
      derived_column: brand_rank {
        sql: row_number() over (order by total_revenue desc) ;;   }
    }
  }
  dimension: brand {
    primary_key:yes
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  dimension: is_brand_rank_top_5 {
    type: yesno
    sql: ${TABLE}.brand_rank <= 5 ;;
  }

  dimension: ranked_brands {
    type: string
    sql: case when ${is_brand_rank_top_5} then
      ${TABLE}.brand_rank||') '||${brand}
       else 'Other' end;;
  }
}
