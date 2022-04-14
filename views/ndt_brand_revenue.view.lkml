view: ndt_brand_revenue {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_revenue {}
      derived_column: brand_rank {
        sql:  row_number() over (order by total_revenue desc) ;;
      }
      filters: {
        field: order_items.delivered_date
        value: "365 days"
      }
    }
  }
  dimension: brand {}
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: brand_rank {
    type: number
    sql: ${TABLE}.brand_rank ;;
  }
  dimension: is_brand_top5{
    type: yesno
    sql:  ${brand_rank} <= 5 ;;
  }
  dimension: ranked_brands {
    type: string
    sql:  case when ${is_brand_top5} = 'Yes' then ${brand_rank}||' - '||${brand} else '6 - Other' end ;;
  }
  measure: percent_sales {
    type: percent_of_total
    sql: ${total_revenue};;
  }
}
