# Synthesize Trending Shows from Primary Page

TVMaze does not provide a dedicated `/trending` endpoint, but the product UI requires a "Trending Now" carousel alongside a paginated shows feed. We decided to extract the top-rated shows from the initial fetch (`/shows?page=0`) to populate "Trending Now", while feeding the remaining shows into the paginated "Popular Shows" feed. This satisfies the mockup requirements dynamically without hardcoding static mock data or complicating network orchestration.
