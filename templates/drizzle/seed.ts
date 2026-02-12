import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { posts } from "./schema";

const client = postgres(process.env.DATABASE_URL!);
const db = drizzle(client);

async function main() {
  console.log("Seeding database...");

  const result = await db
    .insert(posts)
    .values([
      {
        id: "seed-post-1",
        title: "Getting Started with Next.js",
        content: "Next.js App Router ile modern web uygulamaları geliştirin.",
        published: true,
      },
      {
        id: "seed-post-2",
        title: "Drizzle ORM Guide",
        content: "Type-safe veritabanı erişimi için Drizzle ORM kullanımı.",
        published: false,
      },
    ])
    .onConflictDoNothing()
    .returning();

  console.log("Seeded:", result);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await client.end();
  });
