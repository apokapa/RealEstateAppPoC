function GetSubCategories(_categoryid) {
        var procemessage = "<option value=''> Please wait...</option>";
        $("#SubCategoryId").html(procemessage).show();
        var url = "/Base/GetSubCategories/";

        $.ajax({
            url: url,
            data: { categoryid: _categoryid },
            cache: false,
            type: "POST",
            success: function (data) {
                var markup = "<option value=''>All Subcategories</option>";
                for (var x = 0; x < data.length; x++) {
                    markup += "<option value=" + data[x].Value + ">" + data[x].Text + "</option>";
                }
                $("#SubCategoryId").html(markup).show();
            },
            error: function (reponse) {
                alert("error : " + reponse);
            }
        });

}


function GetPrepopulate() {

    var url = "/Base/GetPrepopulate/";
    var jsonArray = []; 
    var _selected = document.getElementById("LocationCodes").value;

    $.ajax({
        url: url,
        data: { selected: _selected },
        cache: false,
        type: "POST",
        success: function (data) {
            jsonArray = data;
            for (var x = 0; x < data.length; x++) {
                $("#LocationCodes").tokenInput("add", { id: data[x].id, name: data[x].name });
            }

        },
        error: function (reponse) {
            //alert("error : " + reponse);
        }
    });

}


$('#BTN').click(function () {

    if (document.getElementById("LocationCodes").value == "") {
        document.getElementById("LocationValidation").innerHTML = "Please select at least one location first";


        return false;
    }

    return true;
});
