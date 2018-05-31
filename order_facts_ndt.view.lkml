view: order_facts_ndt {
  # If necessary, uncomment the line below to include explore_source.
# include: "advanced_data_analyst_bootcamp.model.lkml"

    derived_table: {
      explore_source: order_items {
        column: order_id {}
        column: order_item_count {}
        column: total_revenue {}
        column: user_id { field: users.id }
        column: created_date {}
        derived_column: order_sequence {
          sql:  row_number() OVER (partition by user_id order by created_date) ;;
        }
      }
    datagroup_trigger: order_items_datagroup
    sortkeys: ["id"]
    distribution: "id"
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
    dimension: user_id {
      hidden: yes
      type: number
    }
    dimension: created_date {
      description: "When the order was created"
      hidden: yes
      type: date
    }
    dimension: order_sequence {
      type: number
    }
  }
