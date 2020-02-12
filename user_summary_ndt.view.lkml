# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: user_summary_ndt {
  derived_table: {
    explore_source: users {
      column: age {}
      column: city {}
      column: age_tier {}
      column: country {}
      column: days_since_signup {}
      column: name {}
      column: created_date { field: order_items.created_date }
      column: delivered_date { field: order_items.delivered_date }
      column: sale_price { field: order_items.sale_price }
      column: shipping_time { field: order_items.shipping_time }
      column: returned_date { field: order_items.returned_date }
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
