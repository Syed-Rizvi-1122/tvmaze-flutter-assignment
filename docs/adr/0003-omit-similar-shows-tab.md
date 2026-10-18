# Omit Similar Shows Tab

While the UI design concept includes a "Similar" tab on the show details screen, the TVMaze API does not provide a native endpoint for similar shows. Because the assignment strictly dictates that "Hardcoded TV show data is not allowed" and requires all displayed data to originate from the API, we decided to restrict the show details screen to the three natively supported endpoints: Overview, Episodes (`/shows/{id}/episodes`), and Cast (`/shows/{id}/cast`).
