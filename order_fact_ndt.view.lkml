# If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"
explore: order_fact_ndt {}

view: order_fact_ndt {
  derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: total_revenue {}
      column: order_count {}
      column: id { field: users.id }
      derived_column: order_seq {
        sql: rank() over(partition by id order by order_id) ;;
      }
    }
  }
  dimension: order_id {
    type: number
  }
  dimension: total_revenue {
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_count {
    description: "A count of unique orders"
    type: number
  }
  dimension: id {
    type: number
  }

  dimension: order_seq {
    type: number
  }
}
