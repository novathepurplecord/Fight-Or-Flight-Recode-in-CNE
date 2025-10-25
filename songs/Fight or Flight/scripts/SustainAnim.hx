function onNoteHit(e) {
    if (e.note.isSustainNote) {
        e.animCancelled = true;
    }
}
