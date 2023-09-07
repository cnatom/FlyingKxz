String html = r'''
<html xmlns="http://www.w3.org/1999/xhtml" class="panel-fit"><head><link href="http://yjsxt.cumt.edu.cn/js/lhgdialog/skins/default.css" rel="stylesheet" id="lhgdialoglink"><link href="../App_Themes/Gwork/StyleSheet.css" type="text/css" rel="stylesheet"><script src="/js/gwork.js" type="text/javascript"></script><meta name="renderer" content="webkit"><meta http-equiv="content-type" content="text/html;charset=utf-8"><title>

    中国矿业大学研究生培养管理信息系统

</title><link rel="shortcut icon" href="../images/favicon.ico">
    <style type="text/css">
        .index_more {
            background: #035ca2; /* Old browsers */ /* IE9 SVG, needs conditional override of 'filter' to 'none' */
            background: -moz-linear-gradient(left, #035ca2 0%,white 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, right top, color-stop(0%,#035ca2),color-stop(100%,white)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(left, #035ca2 0%,white 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(left, #035ca2 0%,white 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(left, #035ca2 0%,white 100%); /* IE10+ */
            background: linear-gradient(to right, #035ca2 0%,white 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#035ca2', endColorstr='white',GradientType=1 ); /* IE6-8 */
        }
    </style>
    <script type="text/javascript" src="/js/jquery/jquery.js"></script>
    <link rel="stylesheet" type="text/css" href="/js/jqueryeasyui/etongui.css">
    <script type="text/javascript" src="/js/jqueryeasyui/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="/js/lhgdialog/lhgdialog.min.js"></script>
    <style type="text/css">
        .headerCls {
            text-align: left;
            color: White;
            background: url('../js/jqueryeasyui/images/accordion_dy_h.gif');
        }

        .menuS a {
            font-weight: normal;
            font-size: 12px;
            text-decoration: none;
            color: White;
        }

            .menuS a:hover {
                font-weight: normal;
                font-size: 12px;
                text-decoration: none;
                color: #ffb200;
                border-bottom: 0px;
            }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            var height1 = $(window).height();
            $("#main_layout").attr("style", "width:100%;height:" + height1 + "px");
            $("#main_layout").layout("resize", {
                width: "100%",
                height: height1 + "px"
            });
        });
        $(window).resize(function () {
            var height1 = $(window).height();
            $("#main_layout").attr("style", "width:100%;height:" + height1 + "px");
            $("#main_layout").layout("resize", {
                width: "100%",
                height: height1 + "px"
            });
        });
    </script>
</head>
<body class="easyui-layout layout panel-noscroll" id="main_layout" style="width:100%;height:805px"><div style="left: 0px; top: 0px; visibility: hidden; position: absolute;" class=""><table class="ui_border"><tbody><tr><td class="ui_lt"></td><td class="ui_t"></td><td class="ui_rt"></td></tr><tr><td class="ui_l"></td><td class="ui_c"><div class="ui_inner"><table class="ui_dialog"><tbody><tr><td colspan="2"><div class="ui_title_bar"><div class="ui_title" unselectable="on" style="cursor: move;"></div><div class="ui_title_buttons"><a class="ui_min" href="javascript:void(0);" title="最小化" style="display: inline-block;"><b class="ui_min_b"></b></a><a class="ui_max" href="javascript:void(0);" title="最大化" style="display: inline-block;"><b class="ui_max_b"></b></a><a class="ui_res" href="javascript:void(0);" title="还原"><b class="ui_res_b"></b><b class="ui_res_t"></b></a><a class="ui_close" href="javascript:void(0);" title="关闭(esc键)" style="display: inline-block;">×</a></div></div></td></tr><tr><td class="ui_icon" style="display: none;"></td><td class="ui_main" style="width: auto; height: auto;"><div class="ui_content" style="padding: 10px;"></div></td></tr><tr><td colspan="2"><div class="ui_buttons" style="display: none;"></div></td></tr></tbody></table></div></td><td class="ui_r"></td></tr><tr><td class="ui_lb"></td><td class="ui_b"></td><td class="ui_rb" style="cursor: se-resize;"></td></tr></tbody></table></div><div style="left: 0px; top: 0px; visibility: hidden; position: absolute;" class=""><table class="ui_border"><tbody><tr><td class="ui_lt"></td><td class="ui_t"></td><td class="ui_rt"></td></tr><tr><td class="ui_l"></td><td class="ui_c"><div class="ui_inner"><table class="ui_dialog"><tbody><tr><td colspan="2"><div class="ui_title_bar"><div class="ui_title" unselectable="on" style="cursor: move;"></div><div class="ui_title_buttons"><a class="ui_min" href="javascript:void(0);" title="最小化" style="display: inline-block;"><b class="ui_min_b"></b></a><a class="ui_max" href="javascript:void(0);" title="最大化" style="display: inline-block;"><b class="ui_max_b"></b></a><a class="ui_res" href="javascript:void(0);" title="还原"><b class="ui_res_b"></b><b class="ui_res_t"></b></a><a class="ui_close" href="javascript:void(0);" title="关闭(esc键)" style="display: inline-block;">×</a></div></div></td></tr><tr><td class="ui_icon" style="display: none;"></td><td class="ui_main" style="width: auto; height: auto;"><div class="ui_content" style="padding: 10px;"></div></td></tr><tr><td colspan="2"><div class="ui_buttons" style="display: none;"></div></td></tr></tbody></table></div></td><td class="ui_r"></td></tr><tr><td class="ui_lb"></td><td class="ui_b"></td><td class="ui_rb" style="cursor: se-resize;"></td></tr></tbody></table></div>
<div class="panel layout-panel layout-panel-north panel-htop" style="width: 888px; left: 0px; top: 0px;"><div region="north" border="false" style="padding: 0px; margin: 0px; overflow: hidden; width: 888px; height: 113px;" title="" class="panel-body panel-body-noheader panel-body-noborder layout-body">
    <div class="index_more" style="height: 80px; width: 100%; text-align: left; margin: 1px; padding: 0px">
        <img src="../images/login/banner.png" height="100%"><span style="position: absolute; left: 300px; top: 30px; font-size: 24px; font-weight: bolder; color: White; font-family: 楷体,楷体_GB2312;">
                研究生培养管理信息系统</span>
    </div>
    <div style="height: 30px; width: 100%; margin: 1px; padding: 0px">
        <iframe id="TopMenuFrame" name="TopMenuFrame" frameborder="0" width="100%" scrolling="no" src="TopMenu.aspx" height="100%"></iframe>
    </div>
</div></div>
<div class="panel layout-panel layout-panel-west panel-htop layout-split-west" style="width: 177px; left: 0px; top: 113px;"><div class="panel-header headerCls" style="width: 165px;"><div class="panel-title"><div class="menuS"><a title="快捷菜单" style="margin-left:10px;height:18px" href="LeftMenu.aspx?menu=00" target="MenuFrame">快捷</a> <a title="搜索菜单功能" style="margin-left:10px;height:18px" href="javascript:void(0)" onclick="$.dialog({id:'menuID',title:'搜索菜单功能',content:'url:/Gstudent/LeftMenuSearch.aspx',width:'300px',height:'120px',lock:false,min:true,max:false,drag:true,resize:false});">搜索</a></div></div><div class="panel-tool"><a href="javascript:;" class="panel-tool-collapse" style="display: none;"></a><a href="javascript:;" class="layout-button-left"></a></div></div><div region="west" split="true" title="" style="overflow: hidden; width: 175px; height: 664px;" headercls="headerCls" class="panel-body layout-body" id="">
    <iframe id="MenuFrame" name="MenuFrame" width="100%" scrolling="no" frameborder="0" src="LeftMenu.aspx" height="100%"></iframe>
</div></div>
<div class="panel layout-panel layout-panel-center panel-htop" style="width: 708px; left: 180px; top: 113px;"><div region="center" style="overflow: hidden; width: 708px; height: 692px;" border="false" title="" class="panel-body panel-body-noheader panel-body-noborder layout-body" id="">
    <iframe id="PageFrame" name="PageFrame" frameborder="0" width="100%" scrolling="no" src="loging.aspx" height="100%"></iframe>
</div></div>

<div class="layout-split-proxy-h"></div><div class="layout-split-proxy-v"></div></body></html>
''';