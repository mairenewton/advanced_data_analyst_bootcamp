view: products {
  sql_table_name: public.products ;;

  dimension: id {
    hidden:  yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

    dimension: brand {
      type: string
      sql: ${TABLE}.brand ;;
      link: {
        label: "Google Search for {{ value }}"
        url: "http://www.google.com/search?q={{ value }}"
        icon_url: "http://google.com/favicon.ico"
      }
    }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    link: {
      label: "View Category Detail"
      url: "/explore/advanced_data_analyst_bootcamp/inventory_items?fields=inventory_items.product_category,inventory_items.product_name,inventory_items.count&f[inventory_items.product_category]={{ value | url_encode }}"
    }
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  ##parameter example

  parameter: select_product_detail {
    type: unquoted
    default_value: "department"
    allowed_value: {
      value: "department"
      label: "Department"
    }
    allowed_value: {
      value: "category"
      label: "Category"
    }
    allowed_value: {
      value: "brand"
      label: "Brand"
    }
  }

  # dimension: product_hierarchy {
  #   label_from_parameter: select_product_detail
  #   type: string
  #   sql: ${TABLE}.{% parameter select_product_detail %}
  #     ;;
  # }

  dimension: product_hierarchy {
    label_from_parameter: select_product_detail
    type: string
    sql:
    {% if select_product_detail._parameter_value == 'department' %}
    ${department}
    {% elsif select_product_detail._parameter_value == 'category' %}
    ${category}
    {% else %}
    ${brand}
    {% endif %} ;;
  }







  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
