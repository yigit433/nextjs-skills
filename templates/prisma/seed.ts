import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  console.log("Seeding database...");

  // --- Örnek seed verisi ---
  const post1 = await prisma.post.upsert({
    where: { id: "seed-post-1" },
    update: {},
    create: {
      id: "seed-post-1",
      title: "Getting Started with Next.js",
      content: "Next.js App Router ile modern web uygulamaları geliştirin.",
      published: true,
    },
  });

  const post2 = await prisma.post.upsert({
    where: { id: "seed-post-2" },
    update: {},
    create: {
      id: "seed-post-2",
      title: "Prisma ORM Guide",
      content: "Type-safe veritabanı erişimi için Prisma kullanımı.",
      published: false,
    },
  });

  console.log("Seeded:", { post1, post2 });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
