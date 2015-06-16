var questTree = function (url) {

    var dataUrl = url;
    var tree;
    var root;
    var svg;
    var svgBase;
    var duration = 750;
    var diagonal;
    var length;
    var nodes;
    var toggleShow = true;
    var JsonData;

    function buildTree(treeData) {
        var c = calculateHeight(treeData);
        var height = 800;
        if (c > 1)
            height = c * 200;
        var margin = {
                top: 20,
                right: 120,
                bottom: 20,
                left: 120
            },
            width = 960 - margin.right - margin.left;

        length = width / 3;

        tree = d3.layout.tree()
            .size([height, width]);

        diagonal = d3.svg.diagonal()
            .projection(function (d) {
                return [d.y, d.x];
            });
        svgBase = d3.select("#tree-container").append("svg")
            .attr("width", width + margin.right + margin.left)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        svg = svgBase.append("g");
        sortTree();
        root = treeData;
        root.x0 = height / 2;
        root.y0 = 0;

        update(root);

        setTimeout(function () {
            var nodes = d3.selectAll(".node");
            nodes.each(function (d) {
                renderDetailBox(this, d);
            });
        }, duration + 100);
        //d3.select(self.frameElement).style("height", "500px");
    }

    function sortTree() {
        tree.sort(function (a, b) {
            return b.attr.name.toLowerCase() < a.attr.name.toLowerCase() ? 1 : -1;
        });
    }

    var draggingNode = null;
    var dragStarted = false;
    var selectedNode = null;
    var processingNode = null;
    var dragListener = d3.behavior.drag()
        .on("dragstart", function (d) {
            if (d == root) {
                return;
            }
            dragStarted = true;
            nodes = tree.nodes(d);
            toggleShow = toggleDialog(false);
            d3.event.sourceEvent.stopPropagation();
        })
        .on("drag", function (d) {
            if (d == root) {
                return;
            }
            if (dragStarted)
                initiateDrag(d, this);

            d.x0 += d3.event.dy;
            d.y0 += d3.event.dx;
            var node = d3.select(this);
            node.attr("transform", "translate(" + d.y0 + "," + d.x0 + ")");
        })
        .on("dragend", function (d) {
            if (d == root) {
                return;
            }
            domNode = this;
            if (selectedNode) {
                processingNode = selectedNode;
                updateParent();
            } else {
                //alert("nah");
                endDrag();
            }
        });

    function updateParent() {
        $.ajax({
            type: "POST",
            url: "/campaigns/set_quest_parent",
            data: 'quest_id=' + draggingNode.id + '&parent_id=' + selectedNode.id,
            success: function (response) {
                renderDragEnd();
                endDrag();
            },
            error: function (xhr, status) {
            }

        });
    }

    function renderDragEnd() {
        // now remove the element from the parent, and insert it into the new elements children
        var index = draggingNode.parent.children.indexOf(draggingNode);
        if (index > -1) {
            draggingNode.parent.children.splice(index, 1);
        }
        if (typeof processingNode.children !== 'undefined' || typeof processingNode._children !== 'undefined') {
            if (typeof processingNode.children !== 'undefined') {
                processingNode.children.push(draggingNode);
            } else {
                processingNode._children.push(draggingNode);
            }
        } else {
            processingNode.children = [];
            processingNode.children.push(draggingNode);
        }
        // Make sure that the node being added to is expanded so user can see added node is correctly moved
        expand(processingNode);
        sortTree();
    }

    function initiateDrag(d, domNode) {
        draggingNode = d;
        d3.select(domNode).select('.ghostCircle').attr('pointer-events', 'none');
        d3.selectAll('.ghostCircle').attr('class', 'ghostCircle show');
        d3.select(domNode).attr('class', 'node activeDrag');

        svg.selectAll("g.node").sort(function (a, b) { // select the parent and sort the path's
            if (a.id != draggingNode.id) return 1; // a is not the hovered element, send "a" to the back
            else return -1; // a is the hovered element, bring "a" to the front
        });
        // if nodes has children, remove the links and nodes
        if (nodes.length > 1) {
            // remove link paths
            links = tree.links(nodes);
            nodePaths = svg.selectAll("path.link")
                .data(links, function (d) {
                    return d.target.id;
                }).remove();
            // remove child nodes
            nodesExit = svg.selectAll("g.node")
                .data(nodes, function (d) {
                    return d.id;
                }).filter(function (d, i) {
                    if (d.id == draggingNode.id) {
                        return false;
                    }
                    return true;
                }).remove();

            $('#tree-container .popover').remove();
            $(svg).popover('destroy');
            var allNodes = d3.selectAll(".node");
//            allNodes.each(function (n) {
//                if (this != domNode)
//                    renderDetailBox(this, n);
//            });
        }

        // remove parent link
        parentLink = tree.links(tree.nodes(draggingNode.parent));
        svg.selectAll('path.link').filter(function (d, i) {
            if (d.target.id == draggingNode.id) {
                return true;
            }
            return false;
        }).remove();

        dragStarted = null;
    }

    function endDrag() {
        selectedNode = null;
        d3.selectAll('.ghostCircle').attr('class', 'ghostCircle');
        d3.select(domNode).attr('class', 'node');
        // now restore the mouseover event or we won't be able to drag a 2nd time
        d3.select(domNode).select('.ghostCircle').attr('pointer-events', '');
        updateTempConnector();
        if (draggingNode !== null) {
            update(root);
            //centerNode(draggingNode);
            draggingNode = null;
        }
        setTimeout(function () {
            toggleShow = toggleDialog(true);
        }, duration + 100);
    }

    var updateTempConnector = function () {
        var data = [];
        if (draggingNode !== null && selectedNode !== null) {
            // have to flip the source coordinates since we did this for the existing connectors on the original tree
            data = [{
                source: {
                    x: selectedNode.y0,
                    y: selectedNode.x0
                },
                target: {
                    x: draggingNode.y0,
                    y: draggingNode.x0
                }
            }];
        }
        var link = svg.selectAll(".templink").data(data);

        link.enter().append("path")
            .attr("class", "templink")
            .attr("d", d3.svg.diagonal())
            .attr('pointer-events', 'none');

        link.attr("d", d3.svg.diagonal());

        link.exit().remove();
    };

    var overCircle = function (d) {
        selectedNode = d;
        updateTempConnector();
    };
    var outCircle = function (d) {
        selectedNode = null;
        updateTempConnector();
    };

    function collapse(d) {
        if (d.children) {
            d._children = d.children;
            d._children.forEach(collapse);
            d.children = null;
        }
    }

    function expand(d) {
        if (d._children) {
            d.children = d._children;
            d.children.forEach(expand);
            d._children = null;
        }
    }

    function toggleChildren(d) {
        if (d.children) {
            d._children = d.children;
            d.children = null;
        } else if (d._children) {
            d.children = d._children;
            d._children = null;
        }
        return d;
    }

    function recreateAllPopover() {
        $('#tree-container .popover').remove();
        var allNodes = d3.selectAll(".node");
        allNodes.each(function (n) {
            renderDetailBox(this, n);
        });
        toggleShow = true;
    }

    function update(source) {

        // Compute the new tree layout.
        var nodes = tree.nodes(root).reverse(),
            links = tree.links(nodes);

        // Normalize for fixed-depth.
        // nodes.forEach(function(d) { d.y = d.depth * length; });

        // Update the nodes…
        var node = svg.selectAll("g.node")
            .data(nodes, function (d) {
                return d.id || (d.id = ++i);
            });

        // Enter any new nodes at the parent's previous position.
        var nodeEnter = node.enter().append("g")
            .call(dragListener)
            .attr("class", "node")
            .attr("transform", function (d) {
                return "translate(" + source.y0 + "," + source.x0 + ")";
            });
        //.on("click", click);

        nodeEnter.append("circle")
            .attr("r", 1e-6)
            .style("fill", function (d) {
                return d._children ? "lightsteelblue" : "#fff";
            })
            .on("click", click);

        nodeEnter.append("text")
            .attr("x", function (d) {
                return d.children || d._children ? -15 : 15;
            })
            .attr("dy", ".35em")
            .attr("text-anchor", function (d) {
                return d.children || d._children ? "end" : "start";
            })
            .attr("cursor", "pointer")
            .style("fill-opacity", 1e-6)
            .text(function (d) {
                return "";
            }); //d.attr.name; })

        nodeEnter.append("circle")
            .attr('class', 'ghostCircle')
            .attr("r", 30)
            .attr("opacity", 0.2) // change this to zero to hide the target area
            .style("fill", "lightsteelblue")
            .attr('pointer-events', 'mouseover')
            .on("mouseover", function (node) {
                overCircle(node);
            })
            .on("mouseout", function (node) {
                outCircle(node);
            });

        // Transition nodes to their new position.
        var nodeUpdate = node.transition()
            .duration(duration)
            .attr("transform", function (d) {
                return "translate(" + d.y + "," + d.x + ")";
            });

        nodeUpdate.select("circle")
            .attr("r", 10)
            .style("fill", function (d) {
                return d._children ? "lightsteelblue" : "#fff";
            });

        nodeUpdate.select("text")
            .style("fill-opacity", 1);

        // Transition exiting nodes to the parent's new position.
        var nodeExit = node.exit().transition()
            .duration(duration)
            .attr("transform", function (d) {
                return "translate(" + source.y + "," + source.x + ")";
            })
            .remove();

        nodeExit.select("circle")
            .attr("r", 1e-6);

        nodeExit.select("text")
            .style("fill-opacity", 1e-6);

        // Update the links…
        var link = svg.selectAll("path.link")
            .data(links, function (d) {
                return d.target.id;
            });

        // Enter any new links at the parent's previous position.
        link.enter().insert("path", "g")
            .attr("class", "link")
            .attr("d", function (d) {
                var o = {
                    x: source.x0,
                    y: source.y0
                };
                return diagonal({
                    source: o,
                    target: o
                });
            });

        // Transition links to their new position.
        link.transition()
            .duration(duration)
            .attr("d", diagonal);

        // Transition exiting nodes to the parent's new position.
        link.exit().transition()
            .duration(duration)
            .attr("d", function (d) {
                var o = {
                    x: source.x,
                    y: source.y
                };
                return diagonal({
                    source: o,
                    target: o
                });
            })
            .remove();

        // Stash the old positions for transition.
        nodes.forEach(function (d) {
            d.x0 = d.x;
            d.y0 = d.y;
        });
    }

    function click(d) {
        if (d3.event.defaultPrevented) return;
        $('#tree-container .popover').remove();
        d = toggleChildren(d);
        update(d);
        setTimeout(function () {
            $(svg).popover('destroy');
            var nodes = d3.selectAll(".node");
            nodes.each(function (d) {
                renderDetailBox(this, d);
            });
        }, duration + 100);
    }

    function renderDetailBox(svg, d) {
        $(svg).popover('destroy');
        var placement = d.children ? "left" : "right";
        $(svg).popover({
            'trigger': 'manual',
            'html': true,
            'title': '<a href=' + d.attr.url + '>' + d.attr.name + '</a>',
            'content': renderQuestDetail(d),
            'placement': placement,
            'container': '#tree-container'
        }).popover('show');
    }

    function renderQuestDetail(d) {
        var css = d.attr.status.toString().trim().replace(/ /g, '');
        var count = d.attr.record_count;
        var html = "Description: " + d.attr.description + "<br/>" +
            "Status: <span class='label label-" + css + "'>" + d.attr.status + "</span>";
        if(count>0){
            html+="<br/>Records: "+count.toString();
        }
        return html;
    }

    function calculateHeight(treeData) {
        if (treeData.children == undefined) return;
        var max = treeData.children.length;
        var data = treeData;
        while (data.children != undefined && data.children.length != 0) {
            var arr = flattenCampaignTree(data);
            max = Math.max(max, arr.length);
            data = new Object;
            data.children = [];
            arr.forEach(function (item) {
                if (item.children != undefined)
                    item.children.forEach(function (c) {
                        data.children.push(c);
                    });
            });
        }
        return max;
    }

    function flattenCampaignTree(node) {
        if (node.children == undefined) return [];
        var arr = [];
        node.children.forEach(function (item) {
            arr.push(item);
        });
        return arr;
    }

    function buildTreeRadial(treeData) {

        // Create a svg canvas
        var height = 800;
        var width = 800;
        var diameter = 800;
        var vis = d3.select("#tree-container").append("svg:svg")
            .attr("width", diameter)
            .attr("height", diameter - 150)
            .append("g")
            .attr("transform", "translate(" + diameter / 2 + "," + diameter / 2 + ")");


        // Create a tree "canvas"
        var tree = d3.layout.tree()
            .size([360, diameter / 2 - 120])
            .separation(function (a, b) {
                return (a.parent == b.parent ? 1 : 2) / a.depth;
            });

        var diagonal = d3.svg.diagonal.radial()
            .projection(function (d) {
                return [d.y, d.x / 180 * Math.PI];
            });


        // Preparing the data for the tree layout, convert data into an array of nodes
        var nodes = tree.nodes(treeData);
        // Create an array with all the links
        var links = tree.links(nodes);

        var link = vis.selectAll(".link")
            .data(links)
            .enter().append("svg:path")
            .attr("class", "link")
            .attr("d", diagonal)

        var node = vis.selectAll(".node")
            .data(nodes)
            .enter().append("svg:g")
            .attr("class", "node")
            .attr("transform", function (d) {
                return "rotate(" + (d.x - 90) + ")translate(" + d.y + ")";
            })

        // Add the dot at every node
        node.append("svg:circle")
            .attr("r", 5.5);

        // place the name atribute left or right depending if children
        node.append("svg:text")
            .attr("dy", ".31em")
            .attr("text-anchor", function (d) {
                return d.x < 180 ? "start" : "end";
            })
            .attr("transform", function (d) {
                return d.x < 180 ? "translate(8)" : "rotate(180)translate(-8)";
            })
            .text(function (d) {
                return d.name;
            });
    }

    $('#toggle-dialog').click(function() {
        toggleShow = toggleDialog(!toggleShow);
    });

    function toggleDialog(option) {
        if(option) {
            svg.selectAll("text").remove();
            recreateAllPopover();
            return true;
        }
        else {
            svg.selectAll("text").remove();
            $('#tree-container .popover').remove();
            var nodes = svg.selectAll(".node");
            nodes.append("text")
                .attr("dx", function(d) { return d.children ? -10 : 10; })
                .attr("dy", 3)
                .style("text-anchor", function(d) { return d.children ? "end" : "start"; })
                .text(function(d) { return d.attr.name; });
            return false;
        }
    };

    function CreateTree() {
        $.ajax({
            type: "GET",
            url: dataUrl,
            success: function(data) {
                JsonData = JSON.parse(data);
                buildTree(JsonData);
            }
        });
    }

    CreateTree();
}
