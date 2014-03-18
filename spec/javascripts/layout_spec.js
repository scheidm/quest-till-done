describe("Layout", function()
{
    it("Countdown callback is called when duration reaches 0", function() {
        var callback = jasmine.createSpy();
        timer(callback, 3, 'test');
        waitsFor(function() {
            return callback.callCount > 0;
        });
        runs(function() {
            expect(callback).toHaveBeenCalled();
        });
    });

    it("Button changes back to Start when times up called", function() {
        loadFixtures('layout.html');
        $('#startStopBtn').text('Stop');
        timesUp();
        expect($('#startStopBtn')).toHaveText('Start');
    })
});
