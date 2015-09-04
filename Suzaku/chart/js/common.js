/**
 * Desc: 图表控制js
 * Author: liangqi
 * Date: 15/9/2
 */


/**
 * 请求服务端数据
 * @param type
 */
function requestData(type){
    try{
        window.webkit.messageHandlers.Observe.postMessage({"type":type});
    }catch(e){

    }
}

function formatData(res){
    return {
        tooltip : {
            trigger: 'axis'
        },
        calculable : true,
        xAxis : [
            {
                type : 'category',
                boundaryGap : false,
                data : res.labels
            }
        ],
        yAxis : [
            {
                type : 'value',
                axisLabel : {
                    formatter: '{value} 小时'
                }
            }
        ],
        series : [
            {
                name:'时间',
                type:'line',
                itemStyle:{
                    normal:{
                        lineStyle:{
                            width:3
                        },
                        areaStyle: {
                            type: 'default'
                            ,color: 'rgba(255,127,80,0.1)'
                        }
                    }
                },
                symbolSize : 5,
                data:res.data,
                markPoint : {
                    normal:{
                        borderWidth:8
                    },
                    data : [
                        {type : 'max', name: '最长'},
                        {type : 'min', name: '最短'}
                    ]
                },
                markLine : {
                    data : [
                        {type : 'average', name: '平均值'}
                    ]
                }
            }
        ]
    };
}

function renderData(res){
    var height = document.documentElement.clientHeight,
        chart = $('#chart'),
        width = document.body.clientWidth;

    chart.css({height:height,width:width});
    var myChart = echarts.init(chart[0],theme);
    myChart.setOption(formatData(res));

    renderNotice(res);
}

$('#buttons').on('click','button',function(){
    if (!$(this).hasClass('active')) {
        $(this).addClass('active').siblings().removeClass('active');
        if ($(this).data('index') == 'week') {
            requestData('week');
            //renderData(weekData);
        }else{
            requestData('month');
            //renderData(monthData);
        }
    }
});



var theme = {
    // 默认色板
    color: [
        '#FF7F50'
    ],

    // 图表标题
    title: {
        textStyle: {
            fontWeight: 'normal',
            color: '#008acd'          // 主标题文字颜色
        }
    },

    // 值域
    dataRange: {
        itemWidth: 15,
        color: ['#5ab1ef','#e0ffff']
    },

    // 工具箱
    toolbox: {
        color : ['#1e90ff', '#1e90ff', '#1e90ff', '#1e90ff'],
        effectiveColor : '#ff4500'
    },

    // 提示框
    tooltip: {
        backgroundColor: 'rgba(50,50,50,0.5)',     // 提示背景颜色，默认为透明度为0.7的黑色
        axisPointer : {            // 坐标轴指示器，坐标轴触发有效
            type : 'line',         // 默认为直线，可选为：'line' | 'shadow'
            lineStyle : {          // 直线指示器样式设置
                color: '#008acd',
                width:1,
                type:'dashed'
            },
            crossStyle: {
                color: '#008acd'
            },
            shadowStyle : {                     // 阴影指示器样式设置
                color: 'rgba(200,200,200,0.2)'
            }
        }
    },

    // 区域缩放控制器
    dataZoom: {
        dataBackgroundColor: '#efefff',            // 数据背景颜色
        fillerColor: 'rgba(182,162,222,0.2)',   // 填充颜色
        handleColor: '#008acd'    // 手柄颜色
    },

    // 网格
    grid: {
        borderColor: '#eee',
        y2 : 120
    },

    // 类目轴
    categoryAxis: {
        axisLine: {            // 坐标轴线
            lineStyle: {       // 属性lineStyle控制线条样式
                color: '#888',
                width:1
            }
        },
        splitLine: {           // 分隔线
            lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                color: ['#eee']
            }
        }
    },

    // 数值型坐标轴默认参数
    valueAxis: {
        axisLine: {            // 坐标轴线
            lineStyle: {       // 属性lineStyle控制线条样式
                color: '#888',
                width:1
            }
        },
        splitArea : {
            show : true,
            areaStyle : {
                color: ['rgba(250,250,250,0.1)','rgba(200,200,200,0.1)']
            }
        },
        splitLine: {           // 分隔线
            lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                color: ['#eee']
            }
        }
    },

    polar : {
        axisLine: {            // 坐标轴线
            lineStyle: {       // 属性lineStyle控制线条样式
                color: '#ddd'
            }
        },
        splitArea : {
            show : true,
            areaStyle : {
                color: ['rgba(250,250,250,0.2)','rgba(200,200,200,0.2)']
            }
        },
        splitLine : {
            lineStyle : {
                color : '#ddd'
            }
        }
    },

    timeline : {
        lineStyle : {
            color : '#008acd'
        },
        controlStyle : {
            normal : { color : '#008acd'},
            emphasis : { color : '#008acd'}
        },
        symbol : 'emptyCircle',
        symbolSize : 3
    },

    // 柱形图默认参数
    bar: {
        itemStyle: {
            normal: {
                barBorderRadius: 5
            },
            emphasis: {
                barBorderRadius: 5
            }
        }
    },

    // 折线图默认参数
    line: {
        smooth : true,
        symbol: 'emptyCircle',  // 拐点图形类型
        symbolSize: 3           // 拐点图形大小
    },

    // K线图默认参数
    k: {
        itemStyle: {
            normal: {
                color: '#d87a80',       // 阳线填充颜色
                color0: '#2ec7c9',      // 阴线填充颜色
                lineStyle: {
                    color: '#d87a80',   // 阳线边框颜色
                    color0: '#2ec7c9'   // 阴线边框颜色
                }
            }
        }
    },

    // 散点图默认参数
    scatter: {
        symbol: 'circle',    // 图形类型
        symbolSize: 4        // 图形大小，半宽（半径）参数，当图形为方向或菱形则总宽度为symbolSize * 2
    },

    // 雷达图默认参数
    radar : {
        symbol: 'emptyCircle',    // 图形类型
        symbolSize:3
        //symbol: null,         // 拐点图形类型
        //symbolRotate : null,  // 图形旋转控制
    },

    map: {
        itemStyle: {
            normal: {
                areaStyle: {
                    color: '#ddd'
                },
                label: {
                    textStyle: {
                        color: '#d87a80'
                    }
                }
            },
            emphasis: {                 // 也是选中样式
                areaStyle: {
                    color: '#fe994e'
                }
            }
        }
    },

    force : {
        itemStyle: {
            normal: {
                linkStyle : {
                    color : '#1e90ff'
                }
            }
        }
    },

    chord : {
        itemStyle : {
            normal : {
                borderWidth: 1,
                borderColor: 'rgba(128, 128, 128, 0.5)',
                chordStyle : {
                    lineStyle : {
                        color : 'rgba(128, 128, 128, 0.5)'
                    }
                }
            },
            emphasis : {
                borderWidth: 1,
                borderColor: 'rgba(128, 128, 128, 0.5)',
                chordStyle : {
                    lineStyle : {
                        color : 'rgba(128, 128, 128, 0.5)'
                    }
                }
            }
        }
    },

    gauge : {
        axisLine: {            // 坐标轴线
            lineStyle: {       // 属性lineStyle控制线条样式
                color: [[0.2, '#2ec7c9'],[0.8, '#5ab1ef'],[1, '#d87a80']],
                width: 10
            }
        },
        axisTick: {            // 坐标轴小标记
            splitNumber: 10,   // 每份split细分多少段
            length :15,        // 属性length控制线长
            lineStyle: {       // 属性lineStyle控制线条样式
                color: 'auto'
            }
        },
        splitLine: {           // 分隔线
            length :22,         // 属性length控制线长
            lineStyle: {       // 属性lineStyle（详见lineStyle）控制线条样式
                color: 'auto'
            }
        },
        pointer : {
            width : 5
        }
    },

    textStyle: {
        fontFamily: '微软雅黑, Arial, Verdana, sans-serif'
    }
};

var noticeInfo = {
    nothing : "目前还没有您使用电脑时间的数据统计，请稍安勿躁；如果不会操作该软件，请查阅使用说明。",
    level1  : [
        '非常不错，你每天使用电脑的时间把握的是如此之好，给你一个大大的赞！',
        '你懂得珍爱生命，远离电脑，所以你不会多上网，真要夸夸你啊',
        '你的习惯不错啊，每天上网平均小于2小时，科学上网，继续保持！',
        '看来你在现实世界里真是如鱼得水啊，才让你如此的克制，不沉默虚拟世界',
        '你打败了全国一大批重度依赖电脑的种子选手，你就是第一名，加油！'
    ],
    level2  : [
        '你使用电脑的时间有点过长了哟，还是少上点网，注意身体健康！',
        '悠着点哟亲！你上网时间有点多，给你提个醒，注意休息！',
        '还是不要老玩电脑啦！请多注意一下身边被您遗忘的风景！'
    ],
    level3  : [
        '外面风景挺好的，停一会儿玩电脑吧，注意休息！你使用电脑有点子长啊',
        '长时间对着电脑注意防辐射哟，也别让眼睛太干涩，适当用点眼药水呗！',
        '你至少用了一天的三分之一的时间在玩电脑，你这样真的好吗！'
    ],
    level4  : [
        '我说亲，咋给你说这事呢，一天的时间就这么长，而你却用了多半时间在玩电脑啊，玩出花儿了吗？',
        '你这么喜欢电脑，干脆和它结婚算啦！一天的好时光你都给它了，付出真不少！',
        '你每天使用电脑的时间严重超标！头儿说了，你再这样下去，就把你关禁闭！'
    ]
};

function renderNotice(res){
    var notice = $('#notice');
    if (res && res.data && res.data.length > 0) {
        var total = 0,
            len = res.data.length;
        for(var i=0;i<len;i++){
            total += res.data[i];
        }

        var average = total / len;
        removeAllClass(notice);
        if (average > 12) {
            notice.addClass('alert-danger');
            notice.html(getRandomValue(noticeInfo.level4));
        }else if (average > 8) {
            notice.addClass('alert-warning');
            notice.html(getRandomValue(noticeInfo.level3));
        } else if (average > 2) {
            notice.addClass('alert-info');
            notice.html(getRandomValue(noticeInfo.level2));
        } else if (average > 0) {
            notice.addClass('alert-success');
            notice.html(getRandomValue(noticeInfo.level1));
        }else{
            showNothing(notice);
        }

    }else {
        showNothing(notice);
    }
}

function getRandomValue(arr){
    var index = Math.round(Math.random() * 100) % arr.length;
    return arr[index];
}

function showNothing(notice){
    removeAllClass(notice);
    notice.addClass('alert-success');
    notice.html(noticeInfo.nothing);
}

function removeAllClass(notice){
    notice.removeClass('alert-success');
    notice.removeClass('alert-info');
    notice.removeClass('alert-warning');
    notice.removeClass('alert-danger');
}


$(window).on('load',function(){
    requestData('week');

    /*var weekData = {
        "labels" : ["09.01", "09.02", "09.03", "09.04", "09.05", "09.06"],
        "data" : [14, 12, 10, 18, 20, 14]
    };

    renderData(weekData);*/

});
