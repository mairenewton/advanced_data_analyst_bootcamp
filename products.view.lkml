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
      label: "Google"
      url: "http://www.google.com/search?q={{ value | encode_uri }}"
      icon_url: "http://google.com/favicon.ico"
    }
    link: {
      label: "{{ value }} Analytics Dashboard"
      url: "/dashboards/694?Brand={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
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

  parameter: select_product_detail {
    type: unquoted
    default_value: "department"
    allowed_value: {
      label: "Department"
      value: "department"
    }
    allowed_value: {
      label: "Category"
      value: "category"
    }
    allowed_value: {
      label: "Brand"
      value: "brand"
    }
  }

#   dimension: product_hierarchy {
#     label_from_parameter: select_product_detail
#     type: string
#     sql: ${TABLE}.{% parameter select_product_detail %} ;;
#   }

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
      {% endif %}
      ;;
  }

  filter: choose_a_category_to_compare {
    type: string
    suggest_explore: inventory_items
    suggest_dimension: products.category
  }

  dimension: category_comparator {
    type: string
    sql: CASE
          WHEN {% condition choose_a_category_to_compare %}${category}{% endcondition %}
          THEN ${category}
          ELSE 'All Other Categories'
          END
          ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
