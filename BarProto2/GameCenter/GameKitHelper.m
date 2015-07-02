//
//  GameKitHelper.m
//  NumeroLoco
//
//  Created by Developer on 18/07/14.
//  Copyright (c) 2014 iAm Studio. All rights reserved.
//

#import "GameKitHelper.h"
//#import "RootViewController.h"

@interface GameKitHelper () <GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
    NSMutableDictionary *_achievements;
}
@end

@implementation GameKitHelper

#pragma mark Singleton stuff

+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    NSLog(@"AUTHENTICATRE AL JUGADORRRRRRR");
    GKLocalPlayer* localPlayer =
    [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        NSLog(@"AUTENTIQUE AL JUGADOR");
        [self setLastError:error];
        
        if ([GKLocalPlayer localPlayer].authenticated) {
            _gameCenterFeaturesEnabled = YES;
            [self loadAchievements];
        } else if(viewController) {
            [self presentViewController:viewController];
            //[self loadAchievements];
        } else {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}

#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
    
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}

-(GKAchievement*) getAchievementByID: (NSString*)identifier {
    //1
    GKAchievement* achievement = _achievements[identifier];
    //2
    /*if (achievement == nil) {
        // Create a new achievement object
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        achievement.showsCompletionBanner = NO;
        _achievements[achievement.identifier] = achievement;
    }*/
    return achievement;
}

-(void) reportAchievementWithID: (NSString*)identifier  {
    //1
    if (!_gameCenterFeaturesEnabled) {
        NSLog(@"Player not authenticated"); return;
    }
    //2
    GKAchievement* achievement = [self getAchievementByID:identifier];
    //3
    if (achievement == nil) {
        NSLog(@"SI LO REPORTARE PORQUE NO ESTABA CREADOOOOOOOOOOOOOOOO *************");
        //User hadn't won this achievement
        //Create the achievement
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        achievement.showsCompletionBanner = NO;
        achievement.percentComplete = 100.0;
        _achievements[achievement.identifier] = achievement;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            [self setLastError:error];
            if ([_delegate respondsToSelector: @selector(onAchievementReported:)]) {
                [_delegate onAchievementReported:achievement];
            }
        }];
    } else {
        NSLog(@"NO LO REPORTE PORQUE YA ESTABA CREADOOOOOOOOO *******************************");
    }
}

-(void) loadAchievements {
    //1
    if (!_gameCenterFeaturesEnabled) {
        NSLog(@"Player not authenticated");
        return;
    }
    //2
    [GKAchievement loadAchievementsWithCompletionHandler:
     ^(NSArray* loadedAchievements, NSError* error) {
         [self setLastError:error];
         if (_achievements == nil) { _achievements =
             [[NSMutableDictionary alloc] init];
         } else {
            [_achievements removeAllObjects];
         }
         
         for (GKAchievement* achievement
              in loadedAchievements) {
             NSLog(@"************** Achievement id: %@", achievement.identifier);
             _achievements[achievement.identifier] = achievement;
         }
         if ([_delegate respondsToSelector:
              @selector(onAchievementsLoaded:)]) {
             [_delegate onAchievementsLoaded:_achievements];
         }
     }];
}

-(void) submitScore:(int64_t)score
           category:(NSString*)category {
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        NSLog(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore *gkScore = [[GKScore alloc] initWithLeaderboardIdentifier:category];
    /*GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];*/
    
    //3: Set the score value
    gkScore.value = score;
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if ([self.delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [self.delegate onScoresSubmitted:success];
         }
     }];
}

-(void) findScoresOfFriendsToChallenge {
    //1
    GKLeaderboard *leaderboard =
    [[GKLeaderboard alloc] init];
    
    //2
    leaderboard.identifier = @"Points_Leaderboard";
    
    //3
    leaderboard.playerScope =
    GKLeaderboardPlayerScopeFriendsOnly;
    
    //4
    leaderboard.range = NSMakeRange(1, 100);
    
    //5
    [leaderboard
     loadScoresWithCompletionHandler:
     ^(NSArray *scores, NSError *error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if (success) {
             if (!_includeLocalPlayerScore) {
                 NSMutableArray *friendsScores =
                 [NSMutableArray array];
                 
                 for (GKScore *score in scores) {
                     if (![score.player.playerID
                           isEqualToString:
                           [GKLocalPlayer localPlayer]
                           .playerID]) {
                         [friendsScores addObject:score];
                     }
                 }
                 scores = friendsScores;
             }
             if ([_delegate
                  respondsToSelector:
                  @selector
                  (onScoresOfFriendsToChallengeListReceived:)]) {
                 
                 [_delegate
                  onScoresOfFriendsToChallengeListReceived:scores];
             }
         }
     }];
}

-(void) getPlayerInfo:(NSArray*)playerList {
    //1
    if (_gameCenterFeaturesEnabled == NO)
        return;
    
    //2
    if ([playerList count] > 0) {
        [GKPlayer
         loadPlayersForIdentifiers:
         playerList
         withCompletionHandler:
         ^(NSArray* players, NSError* error) {
             
             [self setLastError:error];
             
             if ([_delegate
                  respondsToSelector:
                  @selector(onPlayerInfoReceived:)]) {
                 
                 [_delegate onPlayerInfoReceived:players];
             }
         }];
    }
}

-(void) sendScoreChallengeToPlayers:(NSArray*)players
                          withScore:(int64_t)score
                            message:(NSString*)message {
    
    //1
    GKScore *gkScore =
    [[GKScore alloc]
     initWithLeaderboardIdentifier:@"Points_Leaderboard"];
    gkScore.value = score;
    
    //2
    /*[gkScore challengeComposeControllerWithPlayers:players message:message completionHandler:^(UIViewController *composeViewController, BOOL didIssueChallenge, NSArray *sentPlayerIDs){
        
    }];*/
    [gkScore issueChallengeToPlayers:players message:message];
}

/*-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    NSLog(@"************** ME SALIIIII DE GAME CENTEEEEERRRRRRR **********************");
}*/

@end
