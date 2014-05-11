var towerDefense = function () {
    buildTowerDefense();
    function buildTowerDefense(){
        $.ajax({
            type: "GET",
            url: "/users/get_td_json",
            success: function (data) {
                var jsonData = JSON.parse(data);
                buildTD(jsonData);
            }
    })};

    function buildTD(jsonData) {

        var margin = 20,
            diameter = 960;

        var color = d3.scale.linear()
            .domain([-1, 5])
            .range(["hsl(152,80%,80%)", "hsl(228,30%,40%)"])
            .interpolate(d3.interpolateHcl);

        var pack = d3.layout.pack()
            .padding(5)
            .size([diameter - margin, diameter - margin])
            .value(function (d) {
                return 1000;
            });

        addPlaceholders(jsonData);

        function getRadius(d) {
            if (d.attr.radius != undefined)
                return d.attr.radius;
            else
                return 1;
        };

        var svg = d3.select("#tower-defense").append("svg")
            .attr("width", diameter)
            .attr("height", diameter)
            .append("g")
            .attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");

        //d3.json(flare, function(error, root) {
        //if (error) return console.error(error);


        root = jsonData;
        var focus = root,
            nodes = pack.nodes(root),
            view;

        removePlaceholders(nodes);

        centerNodes( nodes );

        makePositionsRelativeToZero( nodes );

        var circle = svg.selectAll("circle")
            .data(nodes)
            .enter().append("circle")
            .attr("class", function (d) {
                return d.parent ? d.children ? "node" : "node" : "node node--root";
            })
            .style("fill", function (d) {
                if(d.attr.color == undefined)
                    return "#1f77b4";
                else
                    return d.attr.color;
            })
            .style("fill-opacity", function (d) {
                if(d.attr.color == undefined)
                    return .1;
                else
                    return 1;
            })
            .on("click", function (d) {
                if (focus !== d) zoom(d), d3.event.stopPropagation();
            });

        var text = svg.selectAll("text")
            .data(nodes)
            .enter().append("text")
            .attr("class", "td-label")
            .style("fill-opacity", function (d) {
                return d.parent === root ? 1 : 0;
            })
            .style("display", function (d) {
                return d.parent === root ? null : "none";
            })
            .text(function (d) {
                return d.attr.name;
            });

        var node = svg.selectAll("circle,text");
        var leafnode = svg.selectAll(".node--leaf");

        d3.select("#tower-defense")
            .on("click", function () {
                zoom(root);
            });

        zoomTo([root.x, root.y, root.r * 2 + margin]);

        function zoom(d) {
            $('#tower-defense .popover').remove();

            var focus0 = focus;
            focus = d;

            var transition = d3.transition()
                .duration(d3.event.altKey ? 7500 : 750)
                .tween("zoom", function (d) {
                    var i = d3.interpolateZoom(view, [focus.x, focus.y, focus.r * 2 + margin]);
                    return function (t) {
                        zoomTo(i(t));
                    };
                });

            transition.selectAll("text")
                .filter(function (d) {
                    return d.parent === focus || this.style.display === "inline";
                })
                .style("fill-opacity", function (d) {
                    return d.parent === focus ? 1 : 0;
                })
                .each("start", function (d) {
                    if (d.parent === focus) this.style.display = "inline";
                })
                .each("end", function (d) {
                    if (d.parent !== focus) this.style.display = "none";
                });

            $('#tower-defense .popover').remove();
            setTimeout(function () {
                var nodes = svg.selectAll("circle");
                nodes.on('mousein', function (d) {
                    if (d.id != 0)
                        renderDetailBox2(this, d);
                });
            }, duration + 100);
        }

        function zoomTo(v) {


            var k = diameter / v[2];
            view = v;
            node.attr("transform", function (d) {
                return "translate(" + (d.x - v[0]) * k + "," + (d.y - v[1]) * k + ")";
            });
            circle.attr("r", function (d) {
                return d.r * k;
            });
            // leafnode.attr("r",  function(d) {  return d.attr.radius * k; });
        }
        //});

        d3.select(self.frameElement).style("height", diameter + "px");
        var nodes = svg.selectAll("circle");
        nodes.each(function (d) {
            if (d.id != 0)
                renderDetailBox2(this, d);
        });
    }

    function renderDetailBox2(svg, d) {
        var placement = d.children ? "left" : "right";
        $(svg).popover('destroy');
        $(svg).popover({
            'trigger': 'manual',
            'html': true,
            'title': '<a href=' + d.attr.url + '>' + d.attr.name + '</a>',
            'content': renderQuestDetail2(d),
            'placement': placement,
            'container': '#tower-defense'
        }).on("mouseenter", function () {
            var _this = this;
            $(this).popover("show");
            $(this).siblings(".popover").on("mouseleave", function () {
                $(_this).popover('hide');
            });
            var thisPopover = "#td-popover-" + d.id;
            $(thisPopover).parent().parent().mouseleave(function () {
                $(_this).popover('hide');
            });
        }).on("mouseleave", function () {
            var _this = this;
            setTimeout(function () {
                var thisPopover = "#td-popover-" + d.id;
                if (!$(".popover:hover").length) {
                    $(_this).popover("hide")
                }
            }, 100);
        });
    }

    function renderQuestDetail2(d) {

        var html = "<div id='td-popover-" + d.id + "'>Description: " + d.attr.description;
        if(d.attr.status != undefined) {
            var css = d.attr.status.toString().trim().replace(/ /g,'');
            html += "</br>Status: <span class='label label-"+ css+"'>"+ d.attr.status +"</span>";
        }
        html += "</div>";
        return html;
    }

    function addPlaceholders( node ) {

        if(node.children) {

            for( var i = 0; i < node.children.length; i++ ) {

                var child = node.children[i];
                addPlaceholders( child );
            }

            if(node.children.length === 1) {

                node.children.push({ name:'placeholder', children: [ { name:'placeholder', children:[] }] });
            }
        }
    };

    function removePlaceholders( nodes ) {

        for( var i = nodes.length - 1; i >= 0; i-- ) {

            var node = nodes[i];

            if( node.name === 'placeholder' ) {

                nodes.splice(i,1);
            } else {

                if( node.children ) {

                    removePlaceholders( node.children );
                }
            }
        }
    };

    function centerNodes( nodes ) {

        for( var i = 0; i < nodes.length; i ++ ) {

            var node = nodes[i];

            if( node.children ) {

                if( node.children.length === 1) {

                    var offset = node.x - node.children[0].x;
                    node.children[0].x += offset;
                    reposition(node.children[0],offset);
                }
            }
        }

        function reposition( node, offset ) {

            if(node.children) {
                for( var i = 0; i < node.children.length; i++ ) {

                    node.children[i].x += offset;
                    reposition( node.children[i], offset );
                }
            }
        };
    };

    function makePositionsRelativeToZero( nodes ) {

        //use this to have vis centered at 0,0,0 (easier for positioning)
        var offsetX = nodes[0].x;
        var offsetY = nodes[0].y;

        for( var i = 0; i < nodes.length; i ++ ) {

            var node = nodes[i];

            node.x -= offsetX;
            node.y -= offsetY;
        }
    };
}