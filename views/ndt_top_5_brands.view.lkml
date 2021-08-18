# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: ndt_top5_brands {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_revenue {}
      derived_column: brand_rank {
        sql: row_number() over( partition by total_revenue desc ) ;;
        }
    }
  }
  dimension: brand { primary_key: yes}
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  measure: sum_total_revenue {
    type: sum
    sql: ${total_revenue} ;;
  }

  dimension: brand_rank {
    sql: ${TABLE}.brand_rank ;;
  }

  dimension: is_brand_rank_top_5 {
    type: yesno
    sql: ${brand_rank} <= 5 ;;
  }

  dimension: ranked_brands {
    type: string
    sql: case when ${is_brand_rank_top_5} then
      ${brand_rank}||') '||${brand}
      else 'Other' end;;
  }
}
