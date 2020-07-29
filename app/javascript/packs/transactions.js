
import { select } from "d3-selection";
import { scaleTime, scaleLinear } from "d3-scale";
import { extent, min, max } from "d3-array";
import { line } from "d3-shape";

document.addEventListener("turbolinks:load", init);

function init() {
  const svg = select("#transaction-history");
  if (svg.node() == null || data == null) return;

  const width = svg.attr('width');
  const height = svg.attr('height');

  const x = scaleTime()
    .domain(extent(data, d => new Date(d[1])))
    .range([ 0, width]);

  const y = scaleLinear()
    .domain([min(data, d => d[0]), max(data, d => d[0])])
    .range([ height, 0 ]);

  svg.append("path")
    .datum(data)
    .attr("fill", "none")
    .attr("stroke", "#00BC83")
    .attr("stroke-width", 1)
    .attr("d", line()
      .x(d => x(new Date(d[1])))
      .y(d => y(d[0]))
    )
};
