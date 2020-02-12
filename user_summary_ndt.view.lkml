# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: user_summary_ndt {
  derived_table: {
    explore_source: users {
      column: id {}

      column: order_count { field: order_items.order_count }
      column: total_revenue { field: order_items.total_revenue }
      derived_column: user_rank {
        sql: rank() over (order by total_revenue) ;;
      }
      filters: {
        field: order_items.date_range
        value: "7 days"
      }

    }
  }
  dimension: age {
    value_format: "#,##0"
    type: number
  }
  dimension: city {}
  dimension: age_tier {
    type: tier
    tiers: []
  }
  dimension: country {}
  dimension: days_since_signup {
    type: number
  }
  dimension: name {}
  dimension: created_date {
    description: "When the order was created"
    type: date
  }
  dimension: delivered_date {
    description: "When the order was delivered"
    type: date
  }
  dimension: sale_price {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: shipping_time {
    description: "Shipping time in days"
    type: number
  }
  dimension: returned_date {
    description: "When the order was returned"
    type: date
  }
}
