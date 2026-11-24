# Loading the data
df <- read.csv("data/raw/album_covers.csv.xz")

genres <- c("Blues", "Classical", "Country", "DeathMetal", "DoomMetal",
            "DrumNBass", "Electronic", "Folk", "Grime", "HeavyMetal", "HipHop",
            "Jazz", "LoFi", "Pop", "PsychedelicRock", "Punk", "Reggae", "Rock",
            "Soul", "Techno")

df$genre <- genres[df$label + 1]

df$tooltip <- paste0(
  "<img src='", df$image_base64,
  "' width='150', height='150' />"
)

df_sample <- df[sample(nrow(df), 2000), ]

# PCA
p <- prcomp(df_sample[, 4:(ncol(df_sample)-2)])
plot(p)
summary(p)
biplot(p, scale=TRUE)

# t-SNE
tsne_emb = Rtsne(
  df_sample[, 4:(ncol(df_sample)-2)],
  dims = 2,
  perplexity = 50,
  pca = TRUE,
  max_iter = 500,
  check_duplicates = FALSE
)

df_tsne <- data.frame(
  x = tsne_emb$Y[, 1],
  y = tsne_emb$Y[, 2],
  
  genre = df_sample$genre
)

ggplot(df_tsne, aes(x = x, y = y, color = genre)) +
  geom_point(alpha = 0.7, size = 1.5) +
  labs(
    title = "t-SNE",
    x = "t-SNE 1",
    y = "t-SNE 2",
    color = "Genre"
  ) +
  scale_color_d3(palette = "category20") +
  theme_bw()

# UMAP
umap_emb <- umap(
  df_sample[, 4:(ncol(df_sample)-2)],
  n_neighbors = 5,
  metric = "euclidean",
  min_dist = 0.1
)

df_umap <- data.frame(
  x = umap_emb[, 1],
  y = umap_emb[, 2],
  genre = df_sample$genre,
  tooltip = df_sample$tooltip
)

umap_plot <- ggplot(df_umap, aes(x = x, y = y, color = genre, tooltip = tooltip)) +
  labs(
    title = "UMAP",
    x = "UMAP 1",
    y = "UMAP 2",
    color = "Genre"
  ) +
  geom_point_interactive(size = 1) +
  scale_color_d3(palette = "category20") +
  theme_bw() +
  stat_density_2d() +
  facet_wrap(~ genre)

girafe(ggobj = umap_plot)
