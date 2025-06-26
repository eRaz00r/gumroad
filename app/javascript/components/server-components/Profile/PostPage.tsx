import { EditorContent } from "@tiptap/react";
import { parseISO } from "date-fns";
import * as React from "react";
import { createCast } from "ts-safe-cast";

import { PaginatedComments } from "$app/data/comments";
import { incrementPostViews } from "$app/data/view_event";
import { CreatorProfile } from "$app/parsers/profile";
import { register } from "$app/utils/serverComponentUtil";

import { Icon } from "$app/components/Icons";
import { LoadingSpinner } from "$app/components/LoadingSpinner";
import { CommentsMetadataProvider, PostCommentsSection } from "$app/components/Post/PostCommentsSection";
import { Layout } from "$app/components/Profile/Layout";
import { useRichTextEditor } from "$app/components/RichTextEditor";
import { useUserAgentInfo } from "$app/components/UserAgent";
import { useRunOnce } from "$app/components/useRunOnce";
import { calculateReadingTime, formatReadingTime } from "$app/utils/readingTime";

const dateFormatOptions: Intl.DateTimeFormatOptions = { month: "long", day: "numeric", year: "numeric" };
export const formatPostDate = (date: string | null, locale: string): string =>
  (date ? parseISO(date) : new Date()).toLocaleDateString(locale, dateFormatOptions);

type Props = {
  subject: string;
  slug: string;
  external_id: string;
  purchase_id: string | null;
  published_at: string | null;
  message: string;
  call_to_action: { url: string; text: string } | null;
  download_url: string | null;
  has_posts_on_profile: boolean;
  recent_posts: {
    name: string;
    slug: string;
    published_at: string | null;
    truncated_description: string;
    purchase_id: string | null;
  }[];
  paginated_comments: PaginatedComments | null;
  comments_max_allowed_depth: number;
  creator_profile: CreatorProfile;
};

const PostPage = ({
  subject,
  external_id,
  purchase_id,
  published_at,
  message,
  call_to_action,
  download_url,
  has_posts_on_profile,
  recent_posts,
  paginated_comments,
  comments_max_allowed_depth,
  creator_profile,
}: Props) => {
  const userAgentInfo = useUserAgentInfo();
  const [pageLoaded, setPageLoaded] = React.useState(false);
  React.useEffect(() => setPageLoaded(true), []);
  useRunOnce(() => void incrementPostViews({ postId: external_id }));
  const editor = useRichTextEditor({
    ariaLabel: "Email message",
    initialValue: pageLoaded ? message : null,
    editable: false,
  });
  const publishedAtFormatted = formatPostDate(published_at, userAgentInfo.locale);
  const readingTime = React.useMemo(() => {
    // Try to get from editor first (more accurate)
    if (pageLoaded && editor) {
      try {
        const editorText = editor.getText();
        if (editorText && editorText.trim().length > 0) {
          const editorTime = calculateReadingTime(editorText);
          if (editorTime > 0) return editorTime;
        }
      } catch (error) {
        console.warn('Failed to get text from editor:', error);
      }
    }

    // Fallback to raw message content
    if (message) {
      return calculateReadingTime(message);
    }

    return 0;
  }, [pageLoaded, editor, message]);

  return (
    <Layout className="reader" creatorProfile={creator_profile}>
      <header>
        <h1>{subject}</h1>
        <div style={{ display: "flex", gap: "var(--spacer-2)", alignItems: "center", flexWrap: "wrap" }}>
          <time>{publishedAtFormatted}</time>
          {readingTime >= 1 && (
            <>
              <span className="text-muted" style={{ fontSize: "0.875rem" }}>•</span>
              <div style={{ display: "flex", alignItems: "center", gap: "0.25rem" }}>
                <Icon name="outline-clock" style={{ width: "0.875rem", height: "0.875rem", opacity: 0.7 }} />
                <span className="text-muted" style={{ fontSize: "0.875rem" }}>
                  {formatReadingTime(readingTime)}
                </span>
              </div>
            </>
          )}
        </div>
      </header>
      <article style={{ display: "grid", gap: "var(--spacer-6)" }}>
        {pageLoaded ? null : <LoadingSpinner width="2em" />}
        <EditorContent className="rich-text" editor={editor} />

        {call_to_action || download_url ? (
          <div style={{ display: "grid" }}>
            {call_to_action ? (
              <p>
                <a
                  className="button accent"
                  href={call_to_action.url}
                  target="_blank"
                  style={{ whiteSpace: "normal" }}
                  rel="noopener noreferrer"
                >
                  {call_to_action.text}
                </a>
              </p>
            ) : null}
            {download_url ? (
              <p>
                <a className="button accent" href={download_url}>
                  View content
                </a>
              </p>
            ) : null}
          </div>
        ) : null}
      </article>
      {paginated_comments ? (
        <CommentsMetadataProvider
          value={{
            seller_id: creator_profile.external_id,
            commentable_id: external_id,
            purchase_id,
            max_allowed_depth: comments_max_allowed_depth,
          }}
        >
          <PostCommentsSection paginated_comments={paginated_comments} />
        </CommentsMetadataProvider>
      ) : null}
      {recent_posts.length > 0 ? (
        <>
          {recent_posts.map((post) => (
            <a key={post.slug} href={Routes.custom_domain_view_post_path(post.slug, { purchase_id })}>
              <div>
                <h2>{post.name}</h2>
                <time>{formatPostDate(post.published_at, userAgentInfo.locale)}</time>
              </div>
            </a>
          ))}
          {has_posts_on_profile ? (
            <a href={Routes.root_path()}>
              <h2>See all posts from {creator_profile.name}</h2>
            </a>
          ) : null}
        </>
      ) : null}
    </Layout>
  );
};

export default register({ component: PostPage, propParser: createCast() });
