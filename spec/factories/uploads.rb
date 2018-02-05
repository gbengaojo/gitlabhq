FactoryBot.define do
  factory :upload do
    model { build(:project) }
    size 100.kilobytes
    uploader "AvatarUploader"
    mount_point :avatar
    secret nil
    store ObjectStorage::Store::LOCAL

    # we should build a mount agnostic upload by default
    transient do
      filename 'myfile.jpg'
    end

    # this needs to comply with RecordsUpload::Concern#upload_path
    path { File.join("uploads/-/system", model.class.to_s.underscore, mount_point.to_s, 'avatar.jpg') }

    trait :personal_snippet_upload do
      model { build(:personal_snippet) }
      path { File.join(secret, filename) }
      uploader "PersonalFileUploader"
      secret SecureRandom.hex
    end

    trait :issuable_upload do
      path { File.join(secret, filename) }
      uploader "FileUploader"
      secret SecureRandom.hex
    end

    trait :object_storage do
      store ObjectStorage::Store::REMOTE
    end

    trait :namespace_upload do
      model { build(:group) }
      path { File.join(secret, filename) }
      uploader "NamespaceFileUploader"
      secret SecureRandom.hex
    end

    trait :attachment_upload do
      transient do
        mount_point :attachment
      end

      model { build(:note) }
      uploader "AttachmentUploader"
    end
  end
end
