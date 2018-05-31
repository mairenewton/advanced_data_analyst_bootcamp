# If necessary, uncomment the line below to include explore_source.

# include: "advanced_data_analyst_bootcamp.model.lkml"

  view: order_summary_ndt {
    derived_table: {
      explore_source: order_items {
        column: id { field: users.id }
        column: order_id {}
        column: order_item_count {}
        column: total_revenue {}
        column: created_date { field: inventory_items.created_date }
        derived_column: order_sequence {
          sql: row_number() OVER (PARTITION BY user_id ORDER BY created_date)  ;;
        }
      }
      datagroup_trigger:order_items_datagroup
      sortkeys: ["id"]
      distribution: "id"
    }
    dimension: id {
      type: number
    }
    dimension: order_id {
      type: number
    }
    dimension: order_item_count {
      type: number
    }
    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: created_date {
      type: date
    }
  }
