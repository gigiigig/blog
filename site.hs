--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import Data.List (intersperse, isSuffixOf)
import Data.List.Split (splitOn)
import System.FilePath (combine, splitExtension, takeFileName)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "img/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler
   
    match "js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ directorizeDate `composeRoutes` setExtension "html" 
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls

    {-create ["archive.html"] $ do-}
    {-    route idRoute-}
    {-    compile $ do-}
    {-        posts <- recentFirst =<< loadAll "posts/*"-}
    {-        let archiveCtx =-}
    {-                listField "posts" postCtx (return posts) `mappend`-}
    {-                constField "title" "Archives"            `mappend`-}
    {-                defaultContext-}

    {-        makeItem ""-}
    {-            >>= loadAndApplyTemplate "templates/archive.html" archiveCtx-}
    {-            >>= loadAndApplyTemplate "templates/default.html" archiveCtx-}
    {-            >>= relativizeUrls-}


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

directorizeDate :: Routes
directorizeDate = customRoute (\i -> directorize $ toFilePath i)
  where
    directorize path = dirs ++ ext 
      where
        (dirs, ext) = splitExtension $ concat $
          (intersperse "/" date) ++ ["/"] ++ (intersperse "-" rest)
        (date, rest) = splitAt 3 $ splitOn "-" path
