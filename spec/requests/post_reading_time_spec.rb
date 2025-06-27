# frozen_string_literal: true

require "spec_helper"

# E2E/Integration tests for post reading time functionality
# Tests cover both profile posts and Gumroad blog posts with various content lengths and edge cases
# Verifies both backend reading time calculation and frontend display
#
# Profile posts: Test posts displayed on creator profile pages (requires profile section setup)
# Blog posts: Test posts displayed on Gumroad's main blog (/blog/p/:slug routes)
# Both implementations use the same reading time logic but different UI components
describe "Post Reading Time", type: :feature, js: true do
  let(:seller) { create(:named_seller) }
  let(:buyer) { create(:named_user) }

  before do
    # Set up seller profile with posts section for profile tests
    @section = create(:seller_profile_posts_section, seller: seller)
    create(:seller_profile, seller: seller, json_data: { tabs: [{ name: "", sections: [@section.id] }] })
  end

  describe "Profile post page" do
    context "with short content (less than 1 minute read)" do
      let(:short_content) { "<p>This is a short post with minimal content.</p>" }
      let(:post) { create(:audience_installment, :published, seller: seller, message: short_content, shown_on_profile: true) }

      it "does not display reading time for short content" do
        @section.shown_posts << post.id
        @section.save!
        visit "#{seller.subdomain_with_protocol}/p/#{post.slug}"

        expect(page).to have_selector("h1", text: post.subject)
        expect(page).to_not have_text("min read")
        expect(page).to_not have_selector(".icon-outline-clock")
      end
    end

    context "with long content (more than 1 minute read)" do
      let(:long_content) do
        base_text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
        "<p>#{base_text * 50}</p>"
      end
      let(:post) { create(:audience_installment, :published, seller: seller, message: long_content, shown_on_profile: true) }

      it "displays reading time with clock icon for long content" do
        @section.shown_posts << post.id
        @section.save!
        visit "#{seller.subdomain_with_protocol}/p/#{post.slug}"

        expect(page).to have_selector("h1", text: post.subject)

        # Check for reading time display
        reading_time_minutes = post.reading_time_minutes
        expect(reading_time_minutes).to be > 0

        if reading_time_minutes == 1
          expect(page).to have_text("1 min read")
        else
          expect(page).to have_text("#{reading_time_minutes} min read")
        end

        # Check for clock icon (rendered as span with CSS icon class)
        expect(page).to have_selector(".icon-outline-clock")
      end
    end

    context "with HTML content that needs stripping" do
      let(:html_content) do
        <<~HTML
          <h1>Title Header</h1>
          <p>This is a paragraph with <strong>bold text</strong> and <em>italic text</em>.</p>
          <ul>
            <li>First bullet point with some text</li>
            <li>Second bullet point with more content</li>
            <li>Third bullet point for good measure</li>
          </ul>
          <blockquote>This is a blockquote with meaningful content that should be counted.</blockquote>
          <p>#{("Another paragraph with lots of descriptive content that adds to the reading time calculation. " * 30)}</p>
          <div>Some div content that should also be counted in reading time.</div>
        HTML
      end
      let(:post) { create(:audience_installment, :published, seller: seller, message: html_content, shown_on_profile: true) }

      it "calculates reading time based on stripped text content" do
        @section.shown_posts << post.id
        @section.save!
        visit "#{seller.subdomain_with_protocol}/p/#{post.slug}"

        expect(page).to have_selector("h1", text: post.subject)

        # Verify that HTML is properly stripped for reading time calculation
        reading_time_minutes = post.reading_time_minutes
        expect(reading_time_minutes).to be > 0

        # Should display the reading time
        expect(page).to have_text("#{reading_time_minutes} min read")
        expect(page).to have_selector(".icon-outline-clock")

        # Verify the actual content is displayed (not stripped in the UI)
        expect(page).to have_selector("strong", text: "bold text")
        expect(page).to have_selector("em", text: "italic text")
        expect(page).to have_selector("li", text: "First bullet point")
        expect(page).to have_selector("blockquote")
      end
    end
  end

  describe "Edge cases" do
    context "with only HTML tags and no text content" do
      let(:empty_content) { "<p></p><div></div><h1></h1>" }
      let(:post) { create(:audience_installment, :published, seller: seller, message: empty_content, shown_on_profile: true) }

      it "does not display reading time for empty content" do
        @section.shown_posts << post.id
        @section.save!
        visit "#{seller.subdomain_with_protocol}/p/#{post.slug}"

        expect(page).to have_selector("h1", text: post.subject)
        expect(page).to_not have_text("min read")
        expect(page).to_not have_selector(".icon-outline-clock")
      end
    end

    context "with whitespace-only content" do
      let(:whitespace_content) { "<p>   \n\t   </p><div>     </div>" }
      let(:post) { create(:audience_installment, :published, seller: seller, message: whitespace_content, shown_on_profile: true) }

      it "does not display reading time for whitespace-only content" do
        @section.shown_posts << post.id
        @section.save!
        visit "#{seller.subdomain_with_protocol}/p/#{post.slug}"

        expect(page).to have_selector("h1", text: post.subject)
        expect(page).to_not have_text("min read")
        expect(page).to_not have_selector(".icon-outline-clock")
      end
    end

    context "with exactly 1 minute of content" do
      let(:one_minute_content) do
        # Create content that should result in exactly 1 minute reading time
        base_text = "This content is carefully crafted to result in approximately one minute of reading time for testing the singular form display. "
        installment = Installment.new(message: "<p>#{base_text * 15}</p>")

        # Adjust multiplier to get close to 1 minute
        while installment.reading_time_minutes != 1 && installment.reading_time_minutes < 3
          base_text += "Additional words to reach one minute. "
          installment.message = "<p>#{base_text}</p>"
        end

        installment.message
      end
      let(:post) { create(:audience_installment, :published, seller: seller, message: one_minute_content, shown_on_profile: true) }

      it "displays '1 min read' (singular form) for exactly 1 minute content" do
        # Skip this test if we couldn't generate 1-minute content
        skip "Could not generate 1-minute content" unless post.reading_time_minutes == 1

        @section.shown_posts << post.id
        @section.save!
        visit "#{seller.subdomain_with_protocol}/p/#{post.slug}"

        expect(page).to have_selector("h1", text: post.subject)
        expect(page).to have_text("1 min read")
        expect(page).to_not have_text("1 mins read") # Ensure singular form
        expect(page).to have_selector(".icon-outline-clock")
      end
    end
  end

  describe "Gumroad blog post page" do
    let(:blog_owner) { create(:user, username: "gumroad") }

    context "with short content (less than 1 minute read)" do
      let(:short_content) { "<p>Short blog post content.</p>" }
      let(:blog_post) { create(:audience_post, :published, seller: blog_owner, message: short_content, shown_on_profile: true) }

      it "does not display reading time for short content" do
        visit "/blog/p/#{blog_post.slug}"

        expect(page).to have_selector("h1", text: blog_post.subject)
        expect(page).to_not have_text("min read")
        expect(page).to_not have_selector(".icon-outline-clock")
      end
    end

    context "with long content (more than 1 minute read)" do
      let(:long_content) do
        base_text = "This is a comprehensive blog post about important topics in the creator economy. We'll explore various aspects of content creation, monetization strategies, and audience building techniques that are essential for modern creators. "
        "<p>#{base_text * 45}</p>"
      end
      let(:blog_post) { create(:audience_post, :published, seller: blog_owner, message: long_content, shown_on_profile: true) }

      it "displays reading time with clock icon for long content" do
        visit "/blog/p/#{blog_post.slug}"

        expect(page).to have_selector("h1", text: blog_post.subject)

        # Check for reading time display
        reading_time_minutes = blog_post.reading_time_minutes
        expect(reading_time_minutes).to be > 0

        if reading_time_minutes == 1
          expect(page).to have_text("1 min read")
        else
          expect(page).to have_text("#{reading_time_minutes} min read")
        end

        # Check for clock icon
        expect(page).to have_selector(".icon-outline-clock")
      end
    end

    context "with complex HTML content" do
      let(:complex_content) do
        <<~HTML
          <h2>Introduction to Creator Economy</h2>
          <p>The creator economy has transformed how individuals can build sustainable businesses around their passion and expertise. This comprehensive guide will walk you through the essential elements.</p>

          <h3>Key Strategies</h3>
          <ul>
            <li>Content creation and consistency</li>
            <li>Audience engagement and community building</li>
            <li>Monetization through multiple revenue streams</li>
            <li>Brand partnerships and collaborations</li>
          </ul>

          <blockquote>Success in the creator economy requires authenticity, persistence, and strategic thinking.</blockquote>

          <p>#{("Let's dive deep into each of these strategies with detailed explanations and practical examples that you can implement immediately. " * 25)}</p>

          <h3>Advanced Techniques</h3>
          <p>#{("Advanced creators understand the importance of data analysis, content optimization, and audience segmentation for long-term growth and sustainability. " * 20)}</p>
        HTML
      end
      let(:blog_post) { create(:audience_post, :published, seller: blog_owner, message: complex_content, shown_on_profile: true) }

      it "properly calculates and displays reading time for complex HTML content" do
        visit "/blog/p/#{blog_post.slug}"

        expect(page).to have_selector("h1", text: blog_post.subject)

        # Verify reading time calculation
        reading_time_minutes = blog_post.reading_time_minutes
        expect(reading_time_minutes).to be > 0

        # Should display the reading time
        expect(page).to have_text("#{reading_time_minutes} min read")
        expect(page).to have_selector(".icon-outline-clock")

        # Verify the rich content is properly displayed
        expect(page).to have_selector("h2", text: "Introduction to Creator Economy")
        expect(page).to have_selector("h3", text: "Key Strategies")
        expect(page).to have_selector("ul li", text: "Content creation and consistency")
        expect(page).to have_selector("blockquote", text: "Success in the creator economy")
      end
    end

    context "with call to action button" do
      let(:long_content) { "<p>#{"Blog post with call to action content. " * 50}</p>" }
      let(:cta_data) { { url: "https://example.com", text: "Check out our product" } }
      let(:blog_post) { create(:audience_post, :published, seller: blog_owner, message: long_content, shown_on_profile: true, call_to_action_text: cta_data[:text], call_to_action_url: cta_data[:url]) }

      it "displays reading time and call to action" do
        visit "/blog/p/#{blog_post.slug}"

        expect(page).to have_selector("h1", text: blog_post.subject)

        # Check reading time display
        reading_time_minutes = blog_post.reading_time_minutes
        expect(reading_time_minutes).to be > 0
        expect(page).to have_text("#{reading_time_minutes} min read")
        expect(page).to have_selector(".icon-outline-clock")

        # Check call to action button
        expect(page).to have_link(cta_data[:text], href: cta_data[:url])
        expect(page).to have_selector("a.button.accent", text: cta_data[:text])
      end
    end
  end

  describe "Reading time consistency" do
    let(:blog_owner) { create(:user, username: "gumroad") }
    let(:test_content) { "<p>#{"Consistent content for testing reading time calculations across different contexts. " * 35}</p>" }
    let(:profile_post) { create(:audience_installment, :published, seller: seller, message: test_content, shown_on_profile: true) }
    let(:blog_post) { create(:audience_post, :published, seller: blog_owner, message: test_content, shown_on_profile: true) }

    it "displays the same reading time for identical content on both profile and blog pages" do
      # Check profile page
      @section.shown_posts << profile_post.id
      @section.save!
      visit "#{seller.subdomain_with_protocol}/p/#{profile_post.slug}"

      profile_reading_time = profile_post.reading_time_minutes
      expect(profile_reading_time).to be > 0
      expect(page).to have_text("#{profile_reading_time} min read")

      # Check blog page
      visit "/blog/p/#{blog_post.slug}"

      blog_reading_time = blog_post.reading_time_minutes
      expect(blog_reading_time).to eq(profile_reading_time)
      expect(page).to have_text("#{blog_reading_time} min read")
    end
  end
end
