view: brand_order_facts_ndt { #https://teach.corp.looker.com/explore/advanced_data_analyst_bootcamp/order_items?fields=brand_order_facts_ndt.ranked_brands,order_items.total_revenue&f[products.category]=Jeans&sorts=brand_order_facts_ndt.ranked_brands&limit=500&query_timezone=America%2FNew_York&vis=%7B%22value_labels%22%3A%22legend%22%2C%22label_type%22%3A%22labPer%22%2C%22end_angle%22%3Anull%2C%22type%22%3A%22looker_pie%22%2C%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_view_names%22%3Afalse%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed%22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22trellis%22%3A%22%22%2C%22stacking%22%3A%22%22%2C%22limit_displayed_rows%22%3Afalse%2C%22legend_position%22%3A%22center%22%2C%22point_style%22%3A%22none%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_combined%22%3Atrue%2C%22ordering%22%3A%22none%22%2C%22show_null_labels%22%3Afalse%2C%22show_totals_labels%22%3Afalse%2C%22show_silhouette%22%3Afalse%2C%22totals_color%22%3A%22%23808080%22%2C%22defaults_version%22%3A1%2C%22series_types%22%3A%7B%7D%7D&filter_config=%7B%22products.category%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22Jeans%22%7D%2C%7B%7D%5D%2C%22id%22%3A0%2C%22error%22%3Afalse%7D%5D%7D&dynamic_fields=%5B%5D&origin=share-expanded
    derived_table: {
      explore_source: order_items {
        column: brand { field: products.brand }
        column: total_revenue {}
        derived_column: brand_rank {
          sql: row_number() over (order by total_revenue desc) ;;
        }
#       filters: [order_items.created_date: "365 days"]
#       bind_filters: {
#         from_field: order_items.created_date
#         to_field: order_items.created_date
#       }
        bind_all_filters: yes
      }
    }

    dimension: total_revenue {
      value_format: "$#,##0.00"
      type: number
    }
    dimension: brand {primary_key:yes}
    dimension: brand_rank {
      hidden: yes
      type: number
    }
    dimension: brand_rank_top_5 {
      type: yesno
      sql: ${brand_rank}<=5 ;;
    }
    dimension: ranked_brands {
      type: string
      sql: case when ${brand_rank_top_5} then
      ${brand_rank}||') '||${brand}
      else 'Other' end;;
    }

  }
