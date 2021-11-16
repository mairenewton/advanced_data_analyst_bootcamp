# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: ndt_user_facts {
  derived_table: {
    explore_source: users {
      column: id {}
      column: total_revenue { field: order_items.total_revenue }
      column: order_count { field: order_items.order_count }
    }
  }
  dimension: id {
    primary_key: yes
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_total_revenue  {
    type:  average
    sql:  ${total_revenue};;
    value_format_name: usd
  }

  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
}
