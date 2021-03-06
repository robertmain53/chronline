class Page::Layouts::Frontpage < Layout

  def schema
    {
      'top_headline' => {
        'label' => 'Top Headline Story',
        'type' => 'object',
        'properties' => {
          'article' => {
            'label' => 'Article',
            'extends' => article_schema,
            'required' => false,
          },
          'breaking' => {
              'label' => 'Breaking?',
              'type' => 'boolean',
          },
          'page' => {
            'label' => 'Page',
            'extends' => page_schema,
            'required' => false,
          },
        }
      },
      'slideshow' => {
        'label' => 'Slideshow',
        'type' => 'object',
        'required' => true,
        'properties' => {
          'articles' => {
            'label' => 'Articles',
            'type'=> 'array',
            'required'=> true,
            'items'=> article_schema,
          },
          'pages' => {
            'label' => 'Page IDs',
            'type' => 'array',
            'items' => page_schema,
          },
          'pages_first' => {
            'label' => 'Pages First?',
            'type' => 'boolean',
          }
        }
      },
      'headlines' => {
        'label' => 'Headlines',
        'type'=> 'object',
        'required'=> true,
        'properties'=> {
          'left'=> {
            'type'=> 'array',
            'required'=> true,
            'items'=> article_schema,
          },
          'right' => {
            'type'=> 'array',
            'required'=> true,
            'items'=> article_schema,
          }
        }
      },
      'popular' => {
        'label' => 'Most Commented',
        'extends' => disqus_popular_schema,
      },
      'news' => {
        'label' => 'News',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'sports' => {
        'label' => 'Sports',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'opinion' => {
        'label' => 'Opinion',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'recess' => {
        'label' => 'Recess',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      },
      'towerview' => {
        'label' => 'Towerview',
        'type' => 'array',
        'required' => true,
        'items' => article_schema,
      }
    }
  end

end
