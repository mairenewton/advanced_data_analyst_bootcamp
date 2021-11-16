# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: brand_facts {
  derived_table: {
    explore_source: users {
      column: product_brand { field: inventory_items.product_brand }
      column: total_revenue { field: order_items.total_revenue }
      derived_column: rank {
        sql:  row_number() over(order by total_revenue desc) ;;
      }
    }
  }

  dimension: product_brand {
    primary_key: yes
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: rank {
    type:  number
  }

  dimension: ranked_product_brand {
    sql:
    CASE
      WHEN ${rank} <= 5 THEN ${rank} || '.  ' || ${product_brand}
      ELSE '6. ' || 'Other'
    END ;;
  }
}
