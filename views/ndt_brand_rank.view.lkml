view: ndt_brand_rank {
    derived_table: {
      explore_source: order_items {
        column: brand { field: products.brand }
        column: total_revenue {}
        derived_column: rank {sql: RANK() OVER (ORDER BY total_revenue DESC);; }
      }
    }
    dimension: brand {
      primary_key: yes
    }

    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }

    dimension: rank {
      type: number
      sql: ${TABLE}."rank" ;;
    }
    dimension: brand_rank_top_5 {
      type: yesno
      sql: ${rank} <=5 ;;
    }

    dimension: brand_rank_grouped {
      type: string
      sql: case when ${brand_rank_top_5} then ${brand} else 'Other' end ;;
    }


  }
