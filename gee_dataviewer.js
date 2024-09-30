var datasets = {
    '(*clear*)': '',
    'Epf gap': ['gs://ecoshard-root/esos-c/2024_09_29/cog_epf_gap.tif', 0, 18],
    'Epf natural habitats': ['gs://ecoshard-root/esos-c/2024_09_29/cog_epf_natural_habitats.tif', 0, 40],
    'Farmersincome gap': ['gs://ecoshard-root/esos-c/2024_09_29/cog_farmersincome_gap.tif', 0, 2600],
    'Farmersincome natural habitats': ['gs://ecoshard-root/esos-c/2024_09_29/cog_farmersincome_natural_habitats.tif', 0, 2600],
    'Recreation capacity std': ['gs://ecoshard-root/esos-c/2024_09_29/cog_recreation_capacity_std.tif', 0, 1],
    'Recreation demand std': ['gs://ecoshard-root/esos-c/2024_09_29/cog_recreation_demand_std.tif', 0, 0.1],
    'Recreation provision std': ['gs://ecoshard-root/esos-c/2024_09_29/cog_recreation_provision_std.tif', 0, 1],
    'Water capacity std': ['gs://ecoshard-root/esos-c/2024_09_29/cog_water_capacity_std.tif', 0, 0.5],
    'Water demand std': ['gs://ecoshard-root/esos-c/2024_09_29/cog_water_demand_std.tif', 0, 0.1],
};


var legend_styles = {
  'black_to_red': ['000000', '005aff', '43c8c8', 'fff700', 'ff0000'],
  'blue_to_green': ['440154', '414287', '218e8d', '5ac864', 'fde725'],
  'cividis': ['00204d', '414d6b', '7c7b78', 'b9ac70', 'ffea46'],
  'viridis': ['440154', '355e8d', '20928c', '70cf57', 'fde725'],
  'blues': ['f7fbff', 'c6dbef', '6baed6', '2171b5', '08306b'],
  'reds': ['fff5f0', 'fcbba1', 'fb6a4a', 'cb181d', '67000d'],
  'turbo': ['321543', '2eb4f2', 'affa37', 'f66c19', '7a0403'],
};

var default_legend_style = 'turbo';

function changeColorScheme(key, active_context) {
  active_context.visParams.palette = legend_styles[key];
  active_context.build_legend_panel();
  active_context.updateVisParams();
}

function updateRasterLayer(key, active_context) {
  if (key !== null) {
    if (active_context.last_layer !== null) {
      active_context.map.remove(active_context.last_layer);
    }
    var payload = datasets[key];
    active_context.raster = ee.Image.loadGeoTIFF(payload[0]);
    active_context.visParams.min = payload[1];
    active_context.visParams.max = payload[2];

    active_context.min_val.setValue(active_context.visParams.min, false);
    active_context.max_val.setValue(active_context.visParams.max, false);
    active_context.min_val.setDisabled(false);
    active_context.max_val.setDisabled(false);

    if (active_context.aoi_polygon != null) {
      active_context.raster = active_context.raster.clipToCollection(active_context.aoi_polygon);
    }
    active_context.last_layer = active_context.map.addLayer(
      active_context.raster, active_context.visParams);
  }
}
var canada = ee.FeatureCollection("USDOS/LSIB_SIMPLE/2017")
                .filter(ee.Filter.eq('country_na', 'Canada'));
var linkedMap = ui.Map();
Map.setCenter(-106.3468, 56.1304, 5);


var linker = ui.Map.Linker([ui.root.widgets().get(0), linkedMap]);
// Create a SplitPanel which holds the linked maps side-by-side.
var splitPanel = ui.SplitPanel({
  firstPanel: linker.get(0),
  secondPanel: linker.get(1),
  orientation: 'horizontal',
  wipe: true,
  style: {stretch: 'both'}
});
ui.root.widgets().reset([splitPanel]);

var panel_list = [];
[[Map, 'left'], [linkedMap, 'right']].forEach(function(mapside, index) {
    var active_context = {
      'last_layer': null,
      'raster': null,
      'point_val': null,
      'last_point_layer': null,
      'map': mapside[0],
      'legend_panel': null,
      'visParams': null,
      'raster_key': null,
      'polygon_key': null,
      'last_labels': null,
    };

    active_context.map.style().set('cursor', 'crosshair');
    active_context.visParams = {
      min: 0.0,
      max: 100.0,
      palette: legend_styles[default_legend_style],
    };

    var panel = ui.Panel({
      layout: ui.Panel.Layout.flow('vertical'),
      style: {
        'position': "middle-"+mapside[1],
        'backgroundColor': 'rgba(255, 255, 255, 0.4)'
      }
    });

    var default_control_text = mapside[1]+' controls';
    var controls_label = ui.Label({
      value: default_control_text,
      style: {
        backgroundColor: 'rgba(0, 0, 0, 0)',
      }
    });
    var select = ui.Select({
      items: Object.keys(datasets),
      onChange: function(raster_key, self) {
          active_context.raster_key = raster_key;
          self.setDisabled(true);
          var original_value = self.getValue();
          self.setPlaceholder('loading ...');
          self.setValue(null, false);
          if (active_context.last_layer !== null) {
            active_context.map.remove(active_context.last_layer);
            active_context.last_layer = null;
            active_context.min_val.setDisabled(true);
            active_context.max_val.setDisabled(true);
          }
          if (datasets[raster_key] == '') {
            self.setValue(original_value, false);
            self.setDisabled(false);
            return
          }

          updateRasterLayer(raster_key, active_context);
          self.setValue(original_value, false);
          self.setDisabled(false);
          /*var mean_reducer = ee.Reducer.percentile([10, 90], ['p10', 'p90']);
          var meanDictionary = active_context.raster.reduceRegion({
            reducer: mean_reducer,
            geometry: active_context.map.getBounds(true),
            bestEffort: true,
          });

          ee.data.computeValue(meanDictionary, function (val) {
            if (val['mean_p10'] != val['mean_p90']) {
              active_context.visParams = {
                min: val['mean_p10'],
                max: val['mean_p90'],
                palette: active_context.visParams.palette,
              };
            } else {
              active_context.visParams = {
                min: val['mean_p10'],
                max: val['mean_p90'],
                palette: active_context.visParams.palette,
              };
            }
            active_context.min_val.setValue(active_context.visParams.min, false);
            active_context.max_val.setValue(active_context.visParams.max, false);
            active_context.min_val.setDisabled(false);
            active_context.max_val.setDisabled(false);
            self.setValue(original_value, false);
            self.setDisabled(false);
          });*/
      }
    });

    active_context.min_val = ui.Textbox(
      0, 0, function (value) {
        active_context.visParams.min = +(value);
        updateVisParams();
      });
    active_context.min_val.setDisabled(true);

    active_context.max_val = ui.Textbox(
      100, 100, function (value) {
        active_context.visParams.max = +(value);
        updateVisParams();
      });
    active_context.max_val.setDisabled(true);

    active_context.point_val = ui.Textbox('nothing clicked');
    function updateVisParams() {
      if (active_context.last_layer !== null) {
        active_context.last_layer.setVisParams(active_context.visParams);
      }
    }
    active_context.updateVisParams = updateVisParams;
    select.setPlaceholder('Choose a dataset...');
    var range_button = ui.Button(
      'Detect Range', function (self) {
        self.setDisabled(true);
        var base_label = self.getLabel();
        self.setLabel('Detecting...');
        var mean_reducer = ee.Reducer.percentile([10, 90]);
        var meanDictionary = active_context.raster.reduceRegion({
          reducer: mean_reducer,
          geometry: active_context.map.getBounds(true),
          bestEffort: true,
        });

        ee.data.computeValue(meanDictionary, function (val) {
          var keys = Object.keys(val);
          var p10_key, p90_key;
            for (var i = 0; i < keys.length; i++) {
              var key = String(keys[i]);  // Ensure the key is treated as a string
              if (key.slice(-4) === '_p10') {  // Check if the key ends with '_p10'
                p10_key = key;
              }
              if (key.slice(-4) === '_p90') {  // Check if the key ends with '_p90'
                p90_key = key;
              }
            }
          active_context.min_val.setValue(val[p10_key], false);
          active_context.max_val.setValue(val[p90_key], true);
          self.setLabel(base_label);
          self.setDisabled(false);
        });
      });

    panel.add(controls_label);
    panel.add(select);
    panel.add(ui.Label({
        value: 'min',
        style:{'backgroundColor': 'rgba(0, 0, 0, 0)'}
      }));
    panel.add(active_context.min_val);
    panel.add(ui.Label({
        value: 'max',
        style:{'backgroundColor': 'rgba(0, 0, 0, 0)'}
      }));
    panel.add(active_context.max_val);
    panel.add(range_button);
    panel.add(ui.Label({
      value: 'picked point',
      style: {'backgroundColor': 'rgba(0, 0, 0, 0)'}
    }));
    panel.add(active_context.point_val);
    panel_list.push([panel, active_context.min_val, active_context.max_val, active_context]);
    active_context.map.add(panel);

    function build_legend_panel() {
      var makeRow = function(color, name) {
        var colorBox = ui.Label({
          style: {
            backgroundColor: '#' + color,
            padding: '4px 25px 4px 25px',
            margin: '0 0 0px 0',
            position: 'bottom-center',
          }
        });
        var description = ui.Label({
          value: name,
          style: {
            margin: '0 0 0px 0px',
            position: 'top-center',
            fontSize: '10px',
            padding: 0,
            border: 0,
            textAlign: 'center',
            backgroundColor: 'rgba(0, 0, 0, 0)',
          }
        });

        return ui.Panel({
          widgets: [colorBox, description],
          layout: ui.Panel.Layout.Flow('vertical'),
          style: {
            backgroundColor: 'rgba(0, 0, 0, 0)',
          }
        });
      };

      var names = ['Low', '', '', '', 'High'];
      if (active_context.legend_panel !== null) {
        active_context.legend_panel.clear();
      } else {
        active_context.legend_panel = ui.Panel({
          layout: ui.Panel.Layout.Flow('horizontal'),
          style: {
            position: 'top-center',
            padding: '0px',
            backgroundColor: 'rgba(255, 255, 255, 0.4)'
          }
        });
        active_context.legend_select = ui.Select({
          items: Object.keys(legend_styles),
          placeholder: default_legend_style,
          onChange: function(key, self) {
            changeColorScheme(key, active_context);
        }});
        active_context.map.add(active_context.legend_panel);
      }
      active_context.legend_panel.add(active_context.legend_select);
      // Add color and and names
      for (var i = 0; i<5; i++) {
        var row = makeRow(active_context.visParams.palette[i], names[i]);
        active_context.legend_panel.add(row);
      }
    }

    active_context.map.setControlVisibility(false);
    active_context.map.setControlVisibility({"mapTypeControl": true});
    build_legend_panel();
    active_context.build_legend_panel = build_legend_panel;
});

var clone_to_right = ui.Button(
  'Use this range in both windows', function () {
      panel_list[1][1].setValue(panel_list[0][1].getValue(), false)
      panel_list[1][2].setValue(panel_list[0][2].getValue(), true)
});
var clone_to_left = ui.Button(
  'Use this range in both windows', function () {
      panel_list[0][1].setValue(panel_list[1][1].getValue(), false)
      panel_list[0][2].setValue(panel_list[1][2].getValue(), true)
});

//panel_list.push([panel, min_val, max_val, map, active_context]);
panel_list.forEach(function (panel_array) {
  var map = panel_array[3].map;
  map.onClick(function (obj) {
    var point = ee.Geometry.Point([obj.lon, obj.lat]);
    [panel_list[0][3], panel_list[1][3]].forEach(function (active_context) {
      if (active_context.last_layer !== null) {
        active_context.point_val.setValue('sampling...')
        var point_sample = active_context.raster.sampleRegions({
          collection: point,
        });
        ee.data.computeValue(point_sample, function (val) {
          if (val.features.length > 0) {
            // don't know what the property is called but know there is only 1
            var properties = val.features[0].properties;
            var firstKey = Object.keys(properties)[0];
            var firstValue = properties[firstKey];
            active_context.point_val.setValue(firstValue);
            if (active_context.last_point_layer !== null) {
              active_context.map.remove(active_context.last_point_layer);
            }
            active_context.last_point_layer = active_context.map.addLayer(
              point, {'color': '#FF00FF'});
          } else {
            active_context.point_val.setValue('nodata');
          }
        });
      }
    });
  });
});

panel_list[0][0].add(clone_to_right);
panel_list[1][0].add(clone_to_left);
