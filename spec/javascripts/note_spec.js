describe("Note", function()
{
    it("Check the length of the notes description", function() {
        expect(note.CheckDescription("test")).toEqual(true);
    })
})