export interface NewsArticle {
  title: string;
  description: string;
  image: string;
  url: string;
  publishedAt: string;
  source: {
    name: string;
  };
}

export interface GNewsResponse {
  articles: NewsArticle[];
}
