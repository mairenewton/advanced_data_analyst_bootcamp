view: brand_order_facts_ndt {
    derived_table: {
      explore_source: order_items {
        column: brand { field: products.brand }
        column: total_revenue {}
        derived_column: brand_rank {
          sql: row_number() over (order by total_revenue desc) ;;
        }
#         bind_all_filters: yes
      }
    }
    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: brand {primary_key:yes}
    dimension: brand_rank {
      hidden: yes
      type: number
    }
    dimension: brand_rank_top_10 {
      type: yesno
      sql: ${brand_rank}<=10 ;;
    }
    dimension: ranked_brands {
      type: string
      sql: case when ${brand_rank_top_10} then
      ${brand_rank}||') '||${brand}
      else 'Other' end;;
    }
  }
