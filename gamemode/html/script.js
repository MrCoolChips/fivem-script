$(function () {
    function display(bool) {
        if (bool) {
            $(".container").show();
        } else {
            $(".container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })

    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post(`https://gamemode/exit`, JSON.stringify({}));
            return
        }
    };
    $("#close").click(function () {
        $.post(`https://gamemode/exit`, JSON.stringify({}));
        return
    })

    $("#submit").click(function () {
        $.post('http://gamemode/mission', JSON.stringify({
            mission: 1,})
        );
        $.post(`https://gamemode/exit`, JSON.stringify({}));
        return
    });

    $("#submit2").click(function () {
        $.post('http://gamemode/mission', JSON.stringify({
            mission: 2,})
        );
        $.post(`https://gamemode/exit`, JSON.stringify({}));
        return
    });

    $("#submit3").click(function () {
        $.post('http://gamemode/mission', JSON.stringify({
            mission: 3,})
        );
        $.post(`https://gamemode/exit`, JSON.stringify({}));
        return
    });

    $("#submit4").click(function () {
        $.post('http://gamemode/mission', JSON.stringify({
            mission: 4,})
        );
        $.post(`https://gamemode/exit`, JSON.stringify({}));
        return
    });
        return
})

