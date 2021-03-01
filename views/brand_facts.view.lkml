view: brand_facts {
  derived_table: {
    explore_source: users {
      column: product_brand { field: inventory_items.product_brand }
      column: total_revenue { field: order_items.total_revenue }
      derived_column: brand_rank {
        sql: rank() over(order by total_revenue desc, product_brand asc) ;;
      }
      bind_all_filters: yes
    }

  }

  dimension: product_brand {
    primary_key: yes
    hidden: yes
  }

  dimension: brand {
    type:  string
    sql: case when ${is_top_five} then ${product_brand} else 'Other' end ;;

  }

  dimension: brand_rank {
    hidden:  yes
  }

  dimension: position {
    type:  number
    sql: case when ${brand_rank} <= 5 then ${brand_rank} else 6 end ;;
  }

  dimension: is_top_five {
    type: yesno
    sql: ${brand_rank} <= 5 ;;
  }



  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }



}
