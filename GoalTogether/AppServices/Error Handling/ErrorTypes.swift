//
//  ErrorTypes.swift
//  GoalTogether
//
//  Created by Charlie Page on 7/20/21.
//

import Foundation

// MARK: ErrorLoadingSeason describes errors with loading the user's default Season. Tied to the SeasonRepository.

enum ErrorLoadingSeason: Error {
    case couldNotConvertData
    case NoSeasonFound
    case NewSeasonNil
    case NoDefaultUserSeason
    case DefaultUserSeasonNotFound
}

extension ErrorLoadingSeason: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .couldNotConvertData:
            return NSLocalizedString(
                "Could not convert the subcollection document into a Season", comment: ""
            )
        case .NoSeasonFound:
            return NSLocalizedString(
                "No current season found in subcollection", comment: ""
            )
        case .NewSeasonNil:
            return NSLocalizedString(
                "New Season is still nil after loading", comment: ""
            )
        case .NoDefaultUserSeason:
            return NSLocalizedString(
                "User does not have a default season", comment: ""
            )
        case .DefaultUserSeasonNotFound:
            return NSLocalizedString(
                "Could not find the user default season in array", comment: ""
            )
        }
    }
}


// MARK: UserProfileError is related to the User Profile data model, and describes errors for when the UserProfile can't be updated.

public enum UserProfileError: Error {
    case noUserProfileToUpdate
    case authUserProfileMismatch
    case newOldIDMismatch
}

extension UserProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noUserProfileToUpdate:
            return NSLocalizedString(
                "Could not find a userProfile to update", comment: ""
            )
        case .authUserProfileMismatch:
            return NSLocalizedString(
                "Attempted to update a user that doesn't match the auth user.", comment: ""
            )
        case .newOldIDMismatch:
            return NSLocalizedString(
                "Attempting to update a user with a new user whose ID does not match", comment: ""
            )
        }
    }
}

// MARK: This is an error for adding a user to a group when they have already been added.
public enum AddingUserToGroupError: Error {
    case userAlreadyAdded
    case groupMissingId
    case userMissingId
}

extension AddingUserToGroupError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userAlreadyAdded:
            return NSLocalizedString("User is already added, cannot add again.", comment: "")
        case .groupMissingId:
            return NSLocalizedString("The group does not have an Id, cannot add.", comment: "")
        case .userMissingId:
            return NSLocalizedString("The user does not have an Id, cannot add.", comment: "")
        }
    }
}

public enum UserGroupMismatchError: Error {
    case noGroupInUser
    case noUserInGroup
    case userPendingGroupActive
    case userActiveGroupPending
    case rejectedInUser
    case rejectedInGroup
}


extension UserGroupMismatchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noGroupInUser:
            return NSLocalizedString("The user does not have the group listed in their memberships", comment: "")
        case .noUserInGroup:
            return NSLocalizedString("The group does not have this user listed in its members", comment: "")
        case .userPendingGroupActive:
            return NSLocalizedString("The user has a status of pending, but the group records a status of active.", comment: "")
        case .userActiveGroupPending:
            return NSLocalizedString("The user has a status of active, but the group records a status of pending", comment: "")
        case .rejectedInUser:
            return NSLocalizedString("Only the user has a status of rejected.", comment: "")
        case .rejectedInGroup:
            return NSLocalizedString("Only the group has a status of rejected for this user.", comment: "")
        }
    }
}

public enum ErrorUpdatingUserMembership: Error {
    case userAlreadyInvited
    case userHasNoMembership
    case userHasNoId
    case groupHasNoId
    case updatesMatchCurrentUserMemberships
}


extension ErrorUpdatingUserMembership: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userAlreadyInvited:
            return NSLocalizedString("The user has already been invited to this group", comment: "")
        case .userHasNoId:
            return NSLocalizedString("The user cannot be invited as they have no id.", comment: "")
        case .groupHasNoId:
            return NSLocalizedString("The user cannot be invited to the group as the group has no id.", comment: "")
        case .userHasNoMembership:
            return NSLocalizedString("Can't update the user membership as it can't be found.", comment: "")
        case .updatesMatchCurrentUserMemberships:
            return NSLocalizedString("Tried to update the user's group membership, but requested updates match the current status.", comment: "")
        }
    }
}

public enum ErrorUpdatingGroupMembership: Error {
    case userAlreadyInvited
    case userAlreadyActive
    case noPendingInviteToActivate
    case groupHasNoMember
    case userHasNoId
    case groupHasNoId
    case updatesMatchCurrentMember
    case groupCouldNotBeFound
}


extension ErrorUpdatingGroupMembership: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userAlreadyInvited:
            return NSLocalizedString("The user has already been invited to this group", comment: "")
        case .userAlreadyActive:
            return NSLocalizedString("The user is already an active member of this group", comment: "")
        case .noPendingInviteToActivate:
            return NSLocalizedString("You are trying to activate a user who has not been invited to the group yet.", comment: "")
        case .userHasNoId:
            return NSLocalizedString("The user cannot be invited as they have no id.", comment: "")
        case .groupHasNoId:
            return NSLocalizedString("The user cannot be invited to the group as the group has no id.", comment: "")
        case .groupHasNoMember:
            return NSLocalizedString("Can't update the group membership as it can't be found.", comment: "")
        case .updatesMatchCurrentMember:
            return NSLocalizedString("Tried to update the member in the group, but requested updates match the current status.", comment: "")
        case .groupCouldNotBeFound:
            return NSLocalizedString("Could not find the group.", comment: "")
        }
    }
}

public enum ErrorLoadingFriendInfo: Error {
    case userHasNoId
    case noDefaultSeason
}

extension ErrorLoadingFriendInfo: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userHasNoId:
            return NSLocalizedString("The user is missing an id", comment: "")
        case .noDefaultSeason:
            return NSLocalizedString("There is no default Season for the user; aims cannot be loaded", comment: "")
        }
    }
}
