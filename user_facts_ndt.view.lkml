# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

view: user_facts_ndt {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: order_count {}
      column: order_item_count {}
      column: total_revenue {}
      bind_filters: {
        from_field: user_facts_ndt.date
        to_field: order_items.created_date
      }
    }
#    datagroup_trigger: user_facts_datagroup
#    sortkeys: ["order_id"]
#    distribution: "order_id"
  }

  filter: date {
    type: date
  }


  dimension: id {
    type: number
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
  dimension: order_item_count {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }

  measure: revenue {
    value_format_name: usd
    sql: SUM(${total_revenue}) ;;
    type: number
  }
}
