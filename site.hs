--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll
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

    match "tlp-step-by-step/*" $ do
        route $ setExtension "html"
        compile $ do
            let ctx =
                    field "recent" (\_ -> recentPostList "tlp-step-by-step") `mappend`
                    tlpCtx
            pandocCompiler
                >>= loadAndApplyTemplate "templates/tlp.html"     ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match "typed-fp/*" $ do
        route $ setExtension "html"
        compile $ do
            let ctx =
                    field "recent" (\_ -> recentPostList "typed-fp") `mappend`
                    tfpCtx
            pandocCompiler
                >>= loadAndApplyTemplate "templates/tlp.html"     ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

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

--------------------------------------------------------------------------------
tlpCtx :: Context String
tlpCtx =
    constField "series_title" "Type Level Programming in Scala step by step" `mappend`
    defaultContext

recentPostList :: String -> Compiler String
recentPostList folder = do
    posts   <- fmap (take 10) . chronological =<< itemsByFolder folder
    itemTpl <- loadBody "templates/menu-item.html"
    list    <- applyTemplateList itemTpl defaultContext posts
    return list

itemsByFolder :: String -> Compiler [Item String]
itemsByFolder folder = do
    identifiers <- getMatches $ fromGlob (folder ++ "/*")
    return [Item identifier "" | identifier <- identifiers]

--------------------------------------------------------------------------------
tfpCtx :: Context String
tfpCtx =
    constField "series_title" "Typed Funtional Programming Principles" `mappend`
    defaultContext

