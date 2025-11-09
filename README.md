![nest hero](https://github.com/MrKai77/Nest/blob/backend/hero.jpg?raw=true)

## Inspiration

Rising housing prices have worked against Canadians. For many, finding a house is no longer an achievable goal. As rents soar and home prices climb, the dream of stable housing slips further out of reach, undermining the very foundations of resilient, inclusive, sustainable, and safe cities.

We were inspired by UN Sustainable Development Goal 11 (Sustainable Cities and Communities), which calls for affordable, safe housing for all. But Canada’s housing market has become increasingly opaque; it's harder for renters to tell if they’re being overcharged, and cities lack the unified data they need to respond effectively.

We built Nest to restore fairness and transparency to housing, empowering both citizens and governments to see the full picture and make decisions that strengthen communities instead of dividing them.

## What it does

Nest is a transparent housing platform that helps people find, rent, and sell properties safely and fairly.

Users can browse verified listings across their city, compare real market prices of all properties in a neighbourhood (not just the ones for sale), and gain a clear understanding of local affordability. This transparency prevents price inflation and promotes fairness across renters, buyers, and sellers.

Every user is identity-verified through government-issued ID, which keeps the marketplace real and secure. However, buyer identities remain hidden from sellers until preliminary checks are complete, protecting privacy while maintaining accountability and promoting inclusivity by preventing discriminatory actions from the seller.

For municipal governments, Nest provides access to aggregated housing data and neighbourhood-level analytics, helping policymakers better understand housing affordability trends, rental gaps, and market health.

At its core, Nest is a civic infrastructure tool that builds trust, safety, and transparency into the foundation of how people find homes.

## How we built it

We built Nest as a modular civic platform focused on security, transparency, and personalization. Each component of the system, from authentication to AI matching, was designed to work together seamlessly, creating a product that is both technically robust and socially impactful.

Our database and authentication system is powered by Supabase (PostgreSQL), which securely manages verified user accounts, property listings, and municipal housing data. Every record is protected by strict row-level security policies, maintaining user privacy while allowing for anonymized, aggregated insights that can support government decision-making.

The heart of Nest lies in its Agentic AI matching system, developed in Python and hosted through an embedding model on AWS Bedrock. Each property listing is represented by a weight vector that encodes key attributes such as price, size, location, amenities, and proximity factors. When a user signs in, their preferences, including budget, commute range, bedroom count, and neighbourhood traits, are transformed into a similar embedding space. The AI then calculates cosine similarity scores between the user and all listings, surfacing the most relevant matches. This vector-based approach allows Nest to provide flexible, explainable recommendations that evolve with user behaviour and changing market conditions.

On the front end, we built a native iOS app in Swift that integrates smoothly with Supabase for authentication and data retrieval. The app features map-based property search, and AI-powered housing suggestions, all within a clean and intuitive interface designed for accessibility and trust.

Our backend architecture is lightweight but powerful. It runs on a Python server that communicates with AWS Bedrock for the AI model and handles continuous data ingestion from housing and rental datasets. This ensures the system remains up-to-date and capable of scaling as new cities and datasets are added.

Together, these components create a platform that’s secure, adaptive, and transparent by design, empowering individuals to find homes confidently and enabling governments to make informed, data-driven decisions about housing policy.

## Challenges we ran into

One of our biggest challenges was connecting the backend infrastructure hosted on AWS with the embedding model deployed on AWS Bedrock. While both systems run within the same ecosystem, managing secure API authentication, model invocation, and data flow latency between services required significant debugging. We had to ensure that the embeddings generated for property listings were efficiently stored and retrievable by our Python backend without introducing unnecessary overhead.

We also ran into difficulties linking the backend to our Swift-based iOS frontend. Ensuring smooth communication between Supabase, the AWS-hosted backend, and the app required consistent data formatting, authentication handling, and CORS configuration. Synchronizing these layers, especially during the AI recommendation calls, took careful coordination between our frontend and backend teams.

Finally, integrating real-time updates between these systems was more complex than expected. Balancing performance, privacy, and stability while maintaining a seamless user experience meant reworking parts of our data pipeline and authentication logic multiple times before everything connected smoothly.

## Accomplishments that we're proud of

One of our proudest accomplishments was successfully developing and deploying our Agentic AI model using AWS Bedrock. None of us had worked with AWS before this project, so getting everything set up was both a huge learning curve (endlessly reading documentation) and a major win.

We were able to build an entire end-to-end system that connects our Python backend, embedding model on Bedrock, and Swift iOS frontend. Achieving this level of functionality, especially with a new tech stack, took persistence and collaboration.

Beyond the technical side, we’re proud that Nest became a working prototype of a civic platform that could actually help make housing markets more transparent and equitable. The fact that we turned a complex idea into something tangible, functional, and socially impactful is what we’re most excited about.

## What we learned

This project was full of firsts for our team. None of us had used AWS before, so learning how to deploy a model on AWS Bedrock and connect it with our own backend was an incredible experience. We learned how to optimize API calls and handle data flow between cloud services while ensuring the system remained responsive and safe for users.

We also learned a lot about embeddings and vector similarity models, and how they can be applied beyond just traditional recommendation systems. Seeing how this technology could be used for something civic-minded really broadened our perspective on the social potential of AI.

On the product side, we discovered how challenging it is to balance technical design with civic responsibility. Working on Nest taught us how important it is to design for fairness, transparency, and accessibility. It showed us that meaningful innovation happens at the intersection of technology, ethics, and community impact.

## What's next for Nest
We’ve prepared a four-phase implementation roadmap that begins in 2026 and extends into long-term national growth.

In Phase 1 (Q1 2026), we plan to deploy Nest as a pilot program in partnership with the City of Calgary. This phase will focus on integrating verified housing and rental data from municipal datasets, onboarding at least 1,000 verified users, and collecting feedback from both residents and city housing analysts. Our key metrics will include user acquisition rate, housing data accuracy, and qualitative satisfaction from municipal partners.

Phase 2 (Q2 2026) will focus on refinement and optimization. We’ll improve AI matching accuracy to achieve over 90% reliability, integrate user feedback directly within the app, and establish a partnership with Clear to enhance ID verification. Success will be measured by match accuracy, retention rate, and active engagement with our feedback loop.

In Phase 3 (Q3–Q4 2026), Nest will expand regionally to Red Deer, Airdrie, Okotoks, and Chestermere through new municipal partnerships. Our goals are to secure at least two new municipal contracts and grow our user base to 10,000 verified users, tracking metrics like total verified users, partner adoption, and neighborhood-level data completeness.

Finally, Phase 4 (2028 and onward) will mark Nest’s national expansion. We’ll develop partnerships across Canada and introduce the Nest Transparency Index, a benchmark for measuring housing data openness and fairness. This phase also includes launching an open data portal for researchers and policymakers, and exploring integration with federal open data initiatives. Our key metrics will focus on the number of city partnerships, Transparency Index adoption, and academic or policy citations that use Nest’s data.

Through this roadmap, Nest will evolve from a local pilot into a national platform that strengthens affordability, transparency, and trust in housing across Canada.
